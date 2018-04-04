require 'csv'

class Person < ApplicationRecord
  belongs_to :membership, foreign_key: 'MembershipID', optional: true
  has_one :user

  validates_presence_of :LastName, :FirstName, :MemberType
  validates_format_of   :BirthYear, with: /\A\d\d\d\d\z/, if: :validate_birthyear?
  validates_format_of   :EmailAddress, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, if: Proc.new { |p| !p.EmailAddress.blank? }
  validates_presence_of :Committee1, if: :validate_committee?

  scope :members, -> {joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Honorary', 'Inactive', 'Life', 'Senior', 'Affiliated')")  }
  scope :active, -> {joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Honorary', 'Life', 'Senior')")}
  scope :has_committee, -> {joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Life', 'Senior')")}
  scope :committee, proc {|cmte| where(Committee1: cmte) }

  scope :valid_email, -> {where('subscribe_general is true and EmailAddress is not null and EmailAddress != ""')}

  def validate_birthyear?
    self.MemberType == "Child"
  end

  def validate_committee?
    self.MemberType != "Child" and %w(Active Senior).include?(self.membership.Status)
  end

  def <=>(other)
    s_type = self.MemberType
    o_type = other.MemberType
    if s_type == 'Member'
      -1
    elsif s_type == 'Partner'
      o_type == 'Member' ? 1 : -1
    elsif s_type == 'Child' && o_type == 'Child'
      self.BirthYear <=> other.BirthYear
    else
      1
    end
  end

  def self.binnacle_emails
    alternates = Membership.members.where('email_binnacle is true and alternate_email is not null').map {|m| m.alternate_email}
    email_binnacle = Person.members.where('MemberType = "Member" and EmailAddress is not null and EmailAddress != "" and memberships.email_binnacle is true and memberships.alternate_email is null')
    email_binnacle.concat(Person.members.where('MemberType = "Partner" and EmailAddress is not null and EmailAddress != "" and memberships.email_partner_binnacle is true'))
    alternates + email_binnacle.map {|p| p.EmailAddress}
  end

  def self.email_list(cmte = 'All')
    if cmte == 'All'
      Person.members.valid_email
    else
      Person.has_committee.committee(cmte).valid_email
    end
  end
  
  def generate_email_hash
    self.email_hash = self.class.generate_hash(self.EmailAddress)
    self.save(validate: false)
  end

  def self.to_csv
    people = Person.active.where(MemberType: ['Member', 'Partner']).order('memberships.LastName')
    CSV.generate(col_sep: ",") do |tsv|
      tsv << %w(FirstName LastName MemberLastName MailingName Status Comittee MemberSince)
      people.each do |p|
        m = p.membership
        tsv << [p.FirstName, p.LastName, m.LastName, m.MailingName, m.Status, p.Committee1, m.MemberSince]
      end
    end
  end

    

  private

  def self.generate_hash(str)
    string_to_hash = str + "weeble"
    Digest::SHA1.hexdigest(string_to_hash)
  end

end
