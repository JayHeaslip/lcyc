require 'csv'

class Membership < ApplicationRecord

  @@current_year = Time.now.year
  @@Dues = { Active: 850, Active2016: 283, Senior: 283, Inactive: 50, Associate: 425, Life: 0 }
  @@Mooring_fee = 200   # 80 + 120
  @@Drysail_Fee = 100
  
  has_many :people, foreign_key: "MembershipID", dependent: :destroy
  accepts_nested_attributes_for :people, allow_destroy: true,
                                reject_if: proc { |a| a['FirstName'].blank? }
  
  has_and_belongs_to_many :boats
  accepts_nested_attributes_for :boats, allow_destroy: true,
                                reject_if: proc { |a| a['Name'].blank? && a['Mfg_Size'].blank?}

  has_one :wait_list_entry, dependent: :destroy

  validates :LastName, presence: true, length: { maximum: 30 }
  validates :MailingName, presence: true, length: { maximum: 100 }
  validates :StreetAddress, presence: true, length: { maximum: 50 }
  validates :City, presence: true, length: { maximum: 30 }
  validates :State, presence: true, length: { is: 2}
  validates :Zip, presence: true, length: { maximum: 12 }
  validates :Status, presence: true
  validates :mooring_num, allow_nil: true, inclusion: { in: (0..155) }
  validates :drysail_num, allow_nil: true, inclusion: { in: (1..12) }
  validate :check_type, if: Proc.new {|m| !m.people.empty?}
  validate :ensure_people, if: Proc.new {|m| m.people.empty?}
  validate :member_since, if: Proc.new {|m| m.Status != 'Accepted'}
  validates :installments, allow_nil: true, inclusion: { in: (2..4) }

  # all categories of membership
  scope :members, -> { where(Status: ['Active', 'Active2016', 'Associate', 'Honorary', 'Inactive', 'Life', 'Senior']).order(:LastName) }
  # eligible for a mooring
  scope :active, -> { where(Status: ['Active', 'Active2016', 'Life']).order(:LastName) }
  # all membership except Inactive  
  scope :all_active, -> { where(Status: ['Active', 'Active2016', 'Associate', 'Honorary', 'Life', 'Senior']).order(:LastName) }
  # not on the email announce list
  scope :no_email, -> { where(Status: ['Active', 'Active2016', 'Associate', 'Honorary', 'Life', 'Senior']).order(:LastName) }

  #used for filtering
  scope :lastname, -> (lastname) { where('LastName like ?', "#{lastname}%") }
  scope :since, -> (membersince, operator) { where("MemberSince #{operator} ?", membersince) }
  scope :status, -> (status) { where('Status IN (?)', status) }
  
  def member_since
    # allow setting MemberSince to next year
    errors.add(:MemberSince, "has invalid year") unless (1940..(@@current_year+1)).include?(self.MemberSince)
  end

  def check_type
    errors.add :base, "There can be one and only one 'Member'" if self.count_type('Member') != 1
    errors.add :base, "There can be at most one 'Partner'" if self.count_type('Partner') > 1
  end

  def ensure_people
    errors.add :base, "You must have a Member in the list of people"
  end

  def count_type(type)
    self.people.inject(0) { |cnt, p| cnt + (p.MemberType == type ? 1 : 0) }
  end

  def self.binnacle_hardcopy
    m = Membership.members.joins(:people)
    m.where('email_binnacle is false or (people.MemberType = "Member" and (people.EmailAddress is null or people.EmailAddress = ""))').group(:id).order(:LastName)
  end

  def self.mail_hardcopy
    email_memberships = Person.members.where('subscribe_general is true and EmailAddress is not null and EmailAddress != ""').map{|p| p.membership}.uniq
    mail_memberships = Person.members.where('subscribe_general is false or EmailAddress is null or EmailAddress = ""').map{|p| p.membership}.uniq
    mail_memberships - email_memberships # remove memberships who get an email
  end

  #return boat on mooring owned by the membership
  def moored_boat
    self.boats.select {|b| b.mooring_num == self.mooring_num}[0]
  end

  #return boat on mooring owned by the membership
  def drysailed_boat
    self.boats.select {|b| b.location == 'Parking Lot'}[0]
  end

  def self.unassigned_moorings
    club_moorings = (1..155).to_a
    club_moorings.delete(142) # club mooring (for Dunn)
    membership_moorings = Membership.where('mooring_num is not NULL').map {|m| m.mooring_num}
    club_moorings - membership_moorings
  end

  def self.dues(m)
    @@Dues[m.Status.to_sym] || 0
  end
    
  def self.to_csv(type)
    case type
    when "Log Members" 
      members = self.members.includes(:people).order('LastName, MailingName')
      CSV.generate(col_sep: ",") do |csv|
        csv << %w(LastName MailingName Street City State Zip Country Status MemberSince Mooring BoatName BoatType
                  HomePhone MN MW MC ME Partner Children)
        for m in members
          info = [m.LastName, m.MailingName, m.StreetAddress, m.City, m.State, m.Zip, m.Country, m.Status.sub(/2016/,""),   #hack for the Active2016 members, change it to active for the log
                  m.MemberSince, m.mooring_num].concat(m.boat_info)
          info = info.concat(m.member_info)
          info = info.concat(m.partner_info)
          info = info.concat(m.children_info)
          csv << info
        end
      end
    when "Log Partner Xref" 
      all = Membership.all_active.includes(:people)
      CSV.generate(col_sep: ",") do |csv|
        csv << ["Partner", "",  "Member"]
        for m in all
          member = m.people.where(MemberType: 'Member').first
          partner = m.people.where(MemberType: 'Partner').first
          if partner && member.LastName != partner.LastName
            csv << ["#{partner.LastName}, #{partner.FirstName}", "see", "#{member.LastName}, #{member.FirstName}"]
          end
        end
      end
    when "Billing"
      members = self.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      CSV.generate(col_sep: ",") do |csv|
        csv << %w(LastName MailingName Street City State Zip Country Status Mooring DrySailStorage Email Dues Initiation MooringFee DrySailStorageFee Total)
        for m in members
          dues = Membership.dues(m) || 0
          member = m.people.where('MemberType = "Member"').first
          if member 
            email = member.EmailAddress
          else
	    email = ''
          end
          mooring_fee = m.calculate_mooring_fee
          drysail_fee = m.calculate_drysail_fee
          initiation_due = m.calculate_initiation_installment
          total = dues + mooring_fee + initiation_due + drysail_fee
          csv << [m.LastName, m.MailingName, m.StreetAddress, m.City, m.State, "#{m.Zip}\x09", m.Country, m.Status.sub(/2016/,""), 
                  m.mooring_num, m.drysail_num, email, dues, initiation_due, mooring_fee, drysail_fee, total]
        end
      end
    end
  end
  
  def member_info
    m = self.people.where('MemberType = "Member"').first
    if m
      [m.HomePhone, m.FirstName, m.WorkPhone, m.CellPhone, m.EmailAddress]
    else
      logger.info "No member for #{self.id}, #{self.FirstName} #{self.LastName}"
      [nil, nil, nil, nil, nil]
    end
  end

  def partner_info
    p = self.people.where('MemberType = "Partner"').first
    if p 
      ["#{p.FirstName}\t#{p.WorkPhone}\t#{p.CellPhone}\t#{p.EmailAddress}" ]
    else
      [""]
    end
  end

  def children_info
    cutoff = @@current_year - 25
    children = self.people.where(["MemberType = 'Child' and BirthYear > ? ",cutoff]).order(:BirthYear)
    cstr = nil
    if not children.empty?
      cstr = 'Children: ' + children.map {|c| c.FirstName}.join(", ")
    end
    [cstr]
  end
  
  def boat_info
    #get moored boat name & type
    if self.mooring_num && self.mooring_num != ''
      boat = self.boats.where(["location = 'Mooring' AND mooring_num = ? ", self.mooring_num]).first
      boat = self.boats.first if boat.nil?
    else
        boat = self.boats.first
    end
    if boat
      [boat.Name, boat.Mfg_Size]
    else
      [nil,nil]
    end
  end

  def calculate_initiation_installment
    if !initiation.blank?   # initiation field overrides installment calculation
      return initiation
    elsif !initiation_fee.blank?
      # assume first installment was paid upon joining
      # subsequent installments are billed in the year previous to being due
      # for example: a member joining in 2018, with 3 intallments would be billed for subsequent installments
      # in 2019 (bill generated in 2018) & 2020 (bill generated in 2019)
      if (Time.now.year - self.MemberSince) < (installments - 1)
        initiation_fee/installments
      else
        0
      end
    else
      0
    end
  end

  def calculate_mooring_fee
    if (mooring_num && mooring_num != "" && !skip_mooring)
      @@Mooring_fee
    else
      0
    end
  end

  def calculate_drysail_fee
    if (drysail_num && mooring_num != "")
      @@Drysail_Fee
    else
      0
    end
  end

end
