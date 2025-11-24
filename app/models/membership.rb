require "csv"

class Membership < ApplicationRecord
  @@current_year = Time.now.year
  @@dues = { Active: 1100, Senior: 367, Inactive: 50, Associate: 550, Life: 0 }
  @@mooring_fee = 85
  @@mooring_replacement_fee = 120
  @@drysail_fee = 100

  before_destroy :destroy_boats
  has_many :people, foreign_key: "MembershipID", dependent: :destroy
  accepts_nested_attributes_for :people, allow_destroy: true,
    reject_if: proc { |a| a["FirstName"].blank? }
  has_many :initiation_installments, dependent: :destroy
  accepts_nested_attributes_for :initiation_installments, allow_destroy: true,
    reject_if: proc { |a| a["amount"].blank? }

  # a membership can only have one mooring
  belongs_to :mooring, optional: true
  has_one :drysail

  has_and_belongs_to_many :boats
  accepts_nested_attributes_for :boats, allow_destroy: true,
    reject_if: proc { |a| a["Name"].blank? && a["Mfg_Size"].blank? }

  has_one :wait_list_entry, dependent: :destroy

  validates :LastName, presence: true, length: { maximum: 30 }
  validates :MailingName, presence: true, length: { maximum: 100 }
  validates :StreetAddress, presence: true, length: { maximum: 50 }
  validates :City, presence: true, length: { maximum: 30 }
  validates :State, presence: true, length: { is: 2 }
  validates :Zip, presence: true, length: { maximum: 12 }
  validates :Status, presence: true
  validate :check_type, if: proc { |m| !m.people.empty? }
  validate :check_active_date, if: proc { |m| m.Status == "Active" || m.Status == "Associate" }
  validate :ensure_people, if: proc { |m| m.people.empty? }
  validate :member_since, if: proc { |m| m.Status != "Accepted" }
  validates :installments, allow_nil: true, inclusion: { in: (2..4) }

  # all categories of membership
  scope :members, -> { where(Status: [ "Active", "Associate", "Honorary", "Inactive", "Life", "Senior" ]).order(:LastName) }
  # members who should get a bill
  scope :billed_members, -> { where('Status NOT IN ("Honorary", "Life", "Non-member")').order(:LastName) }
  # eligible for a mooring
  scope :active, -> { where(Status: [ "Active", "Life", "Associate" ]).order(:LastName) }
  # adding accepted for QBO since they can be billed for mooring wait list
  scope :accepted, -> { where(Status: [ "Accepted" ]).order(:LastName) }
  # all membership except Inactive
  scope :all_active, -> { where(Status: [ "Active", "Associate", "Honorary", "Life", "Senior" ]).order(:LastName) }
  # not on the email announce list
  scope :no_email, -> { where(Status: [ "Active", "Associate", "Honorary", "Life", "Senior" ]).order(:LastName) }

  # used for filtering
  scope :lastname, ->(lastname) { where("LastName like ?", "#{lastname}%") }
  scope :since, ->(membersince, operator) { where("MemberSince #{operator} ?", membersince) }
  scope :status, ->(status) { where("Status IN (?)", status) }

  def member_since
    # allow setting MemberSince to next year
    errors.add(:MemberSince, "has invalid year") unless (1940..(@@current_year + 1)).cover?(self.MemberSince)
  end

  def check_type
    errors.add :base, "There can be one and only one 'Member'" if count_type("Member") != 1
    errors.add :base, "There can be at most one 'Partner'" if count_type("Partner") > 1
  end

  def check_active_date
    errors.add(:active_date, "can not be blank") unless self.active_date != nil
    errors.add(:active_date, "year has to match Member Since year") unless self.active_date&.year == self.MemberSince
  end

  def mooring_eligible
    self.Status.in? [ "Active", "Life", "Associate" ]
  end

  def wait_list_eligible
    self.Status.in? [ "Accepted", "Active", "Life", "Associate" ]
  end

  # return first available mooring from an array of memberships
  def self.mooring_available(memberships)
    memberships.each do |m|
      return m.mooring if m.mooring&.boat.nil?
    end
    nil
  end

  # return first available drysail spot from an array of memberships
  def self.drysail_available(memberships)
    memberships.each do |m|
      return m.drysail if m.drysail&.boat.nil?
    end
    nil
  end

  def self.list_to_csv
    members = self.members.includes(:people).order("LastName, MailingName")
    CSV.generate(col_sep: ",") do |csv|
      csv << %w[MailingName FirstName LastName Type Birthyear Cell Email MemberSince]
      members.each do |m|
        m.people.each do |p|
          csv << [ m.MailingName, p.FirstName, p.LastName, p.MemberType, p.BirthYear, p.CellPhone, p.EmailAddress, m.MemberSince ]
        end
      end
    end
  end

  def ensure_people
    errors.add :base, "You must have a Member in the list of people"
  end

  def count_type(type)
    people.inject(0) { |cnt, p| cnt + ((p.MemberType == type) ? 1 : 0) }
  end

  def self.mail_hardcopy
    email_memberships = Person.members.where('subscribe_general is true and EmailAddress is not null and EmailAddress != ""').map { |p| p.membership }.uniq
    mail_memberships = Person.members.where('subscribe_general is false or EmailAddress is null or EmailAddress = ""').map { |p| p.membership }.uniq
    mail_memberships - email_memberships # remove memberships who get an email
  end

  def self.dues(m)
    m.associate_check
    @@dues[m.Status.to_sym] || 0
  end

  def self.to_csv(type)
    case type
    when "Log Members"
      members = self.members.includes(:people).order("LastName, MailingName")
      CSV.generate(col_sep: ",") do |csv|
        csv << %w[LastName MailingName Street City State Zip Country Status MemberSince Mooring BoatName BoatType
          HomePhone MN MW MC ME Partner Children]
        members.each do |m|
          info = [ m.LastName, m.MailingName, m.StreetAddress, m.City, m.State, m.Zip, m.Country, m.Status,
            m.MemberSince, m.mooring ? m.mooring.id : "" ].concat(m.boat_info)
          info = info.concat(m.member_info)
          info = info.concat(m.partner_info)
          info = info.concat(m.children_info)
          csv << info
        end
      end
    when "Log Partner Xref"
      all = Membership.all_active.includes(:people)
      CSV.generate(col_sep: ",") do |csv|
        csv << [ "Partner", "", "Member" ]
        all.each do |m|
          member = m.people.where(MemberType: "Member").first
          partner = m.people.where(MemberType: "Partner").first
          if partner && member.LastName != partner.LastName
            csv << [ "#{partner.LastName}, #{partner.FirstName}", "see", "#{member.LastName}, #{member.FirstName}" ]
          end
        end
      end
    when "Billing"
      members = self.members.where('Status NOT IN ("Honorary", "Life")').includes(:people)
      CSV.generate(col_sep: ",") do |csv|
        csv << %w[LastName MailingName Street City State Zip Country Status Mooring DrySailStorage Email Dues Initiation MooringFee DrySailStorageFee DocksAssessment Total]
        members.each do |m|
          dues = Membership.dues(m) || 0
          member = m.people.where('MemberType = "Member"').first
          email = if member
            member.EmailAddress
          else
            ""
          end
          mooring_fee = m.calculate_mooring_fee + m.calculate_mooring_replacement_fee
          drysail_fee = m.calculate_drysail_fee
          initiation_due = m.calculate_initiation_installment
          docks_assessment = m.calculate_docks_assessment
          total = dues + mooring_fee + initiation_due + drysail_fee + docks_assessment
          csv << [ m.LastName, m.MailingName, m.StreetAddress, m.City, m.State, m.Zip, m.Country, m.Status,
            m.mooring&.id, m.drysail&.id, email, dues, initiation_due, mooring_fee, drysail_fee, docks_assessment, total ]
        end
      end
    when "Evite"
      members = self.members.all_active
      CSV.generate(col_sep: ",") do |csv|
        csv << %w[LastName MailingName Email Cell]
        members.each do |m|
          email = m.primary_email
          cell = m.primary_cell
          csv << [ m.LastName, m.MailingName, email, cell ]
        end
      end
    end
  end

  def member_info
    member = people.where('MemberType = "Member"').first
    if member
      [ member.HomePhone, member.FirstName, member.WorkPhone, member.CellPhone, member.EmailAddress ]
    else
      logger.info "No member for #{id}, #{self.MailingName}"
      [ nil, nil, nil, nil, nil ]
    end
  end

  def partner_info
    p = people.where('MemberType = "Partner"').first
    if p
      [ "#{p.FirstName}\t#{p.WorkPhone}\t#{p.CellPhone}\t#{p.EmailAddress}" ]
    else
      [ "" ]
    end
  end

  def children_info
    cutoff = @@current_year - 25
    children = people.where([ "MemberType = 'Child' and BirthYear > ? ", cutoff ]).order(:BirthYear)
    cstr = nil
    if !children.empty?
      cstr = "Children: " + children.map { |c| c.FirstName }.join(", ")
    end
    [ cstr ]
  end

  def boat_info
    # get moored boat name & type
    if mooring
      boat = boats.where("location = 'Mooring'").first
      boat = boats.first if boat.nil?
    else
      boat = boats.first
    end
    if boat
      [ boat.Name, boat.Mfg_Size ]
    else
      [ nil, nil ]
    end
  end

  def calculate_initiation_installment
    installment = initiation_installments.where(year: Time.now.year + 1).first
    if installment
      installment.amount
    # #if !initiation.blank?   # initiation field overrides installment calculation
    ##  return initiation
    # #elsif !initiation_fee.blank?
    ##  # assume first installment was paid upon joining
    ##  # subsequent installments are billed in the year previous to being due
    ##  # for example: a member joining in 2018, with 3 intallments would be billed for subsequent installments
    ##  # in 2019 (bill generated in 2018) & 2020 (bill generated in 2019)
    ##  if (Time.now.year - self.MemberSince) < (installments - 1)
    ##    initiation_fee/installments
    ##  else
    ##    0
    ##  end
    else
      0
    end
  end

  def calculate_mooring_fee
    if mooring && !skip_mooring
      @@mooring_fee
    else
      0
    end
  end

  def calculate_docks_assessment
    if self.Status == "Active"
      125
    elsif self.Status == "Associate"
      62
    else
      0
    end
  end

  def primary_email
    member_email = people.where('MemberType = "Member"').first&.EmailAddress
    partner_email = people.where('MemberType = "Partner"').first&.EmailAddress
    (member_email.blank? || (prefer_partner_email && !partner_email.blank?)) ? partner_email : member_email
  end

  def cc_email
    member_email = people.where('MemberType = "Member"').first&.EmailAddress
    partner_email = people.where('MemberType = "Partner"').first&.EmailAddress
    (member_email.blank? || (prefer_partner_email && !partner_email.blank?)) ? member_email : partner_email
  end

  def primary_cell
    member_cell = people.where('MemberType = "Member"').first&.CellPhone
    partner_cell = people.where('MemberType = "Partner"').first&.CellPhone
    (member_cell.blank? || (prefer_partner_email && !partner_cell.blank?)) ? partner_cell : member_cell
  end

  def calculate_mooring_replacement_fee
    if mooring && !skip_mooring
      @@mooring_replacement_fee
    else
      0
    end
  end

  def calculate_drysail_fee
    if drysail
      @@drysail_fee
    else
      0
    end
  end

  # delete boats if this membership is the only one listed as having it
  def destroy_boats
    boats.each do |b|
      if b.memberships.size == 1
        b.delete
      end
    end
  end

  def remove_boat_from_mooring
    boats.each do |b|
      if b.location == "Mooring"
        b.location = ""
        b.mooring = nil
        b.save
      end
    end
  end

  def remove_boat_from_drysail
    boats.each do |b|
      if b.location == "Parking Lot"
        b.location = ""
        b.drysail = nil
        b.save
      end
    end
  end

  def check_mooring
    boats.each do |b|
      if b.location == "Mooring"
        b.mooring = mooring
        b.save
      end
    end
  end

  def check_drysail
    boats.each do |b|
      if b.location == "Parking Lot"
        b.drysail = drysail
        b.save
      end
    end
  end

  def active_year
    member = people.where(MemberType: "Member").first
    partner = people.where(MemberType: "Partner").first
    m_birthyear = member.BirthYear if member.BirthYear
    p_birthyear = partner.BirthYear if partner&.BirthYear

    # note membersince+6 ensures that Associates get a full 5 years from the date
    # they became active (per the bylaws) because we bill yearly but track active date by the day
    active_year_criteria = [ self.MemberSince + 6, m_birthyear + 40 ]
    active_year_criteria.push(p_birthyear + 40) if p_birthyear
    active_year_criteria.min
  end

  def associate_check
    if self.Status == "Associate"
      if active_year <= Time.now.year+1
        logger.info "#{self.MailingName} -> Active"
        Membership.set_flash_message("#{self.MailingName} needs to be made Active")
        #self.Status = "Active"
        #change_status_date = Time.now.strftime("%Y-%m-%d")
        #self.save
      end
    end
  end

  def self.set_flash_message(msg)
    @@flash_message = @@flash_message + msg + "<br>"
  end

  def self.reset_flash_message
    @@flash_message = ""
  end

  def self.flash_message
    @@flash_message
  end
end
