require "csv"

class Person < ApplicationRecord
  belongs_to :membership, foreign_key: "MembershipID", optional: true
  belongs_to :committee, optional: true
  has_one :user

  validates_presence_of :LastName, :FirstName, :MemberType
  validates_format_of :BirthYear, with: /\A\d\d\d\d\z/, if: :validate_birthyear?
  validates_format_of :EmailAddress, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, if: proc { |p| !p.EmailAddress.blank? }
  validates_presence_of :Committee1, if: :validate_committee?

  scope :members, -> { joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Honorary', 'Inactive', 'Life', 'Senior', 'Affiliated')") }
  scope :active, -> { joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Honorary', 'Life', 'Senior')") }
  scope :resigned, -> { joins(:membership).where("memberships.Status = 'Resigned'") }
  scope :has_committee, -> { joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Life', 'Senior')") }
  scope :committee, proc { |cmte| where(Committee1: cmte) }

  scope :valid_email, -> { where('subscribe_general is true and EmailAddress is not null and EmailAddress != ""') }
  scope :maillist, -> { where('subscribe_general is true and EmailAddress is not null and EmailAddress != "" and MemberType = "MailList"') }

  def validate_birthyear?
    self.MemberType == "Child"
  end

  def validate_committee?
    if membership.nil?  # creating the membership, don't look at status
      self.MemberType != "Child"
    else
      self.MemberType != "Child" and %w[Accepted Active Associate Life Senior].include?(membership.Status)
    end
  end

  def <=>(other)
    s_type = self.MemberType
    o_type = other.MemberType
    if s_type == "Member"
      -1
    elsif s_type == "Partner"
      (o_type == "Member") ? 1 : -1
    elsif s_type == "Child" && o_type == "Child"
      self.BirthYear <=> other.BirthYear
    else
      1
    end
  end

  def self.email_list(cmte = "All", filter = false)
    if cmte == "All"
      if filter
        Person.members.valid_email.where("select_email is true")
      else
        Person.members.valid_email.to_a.concat(Person.maillist)
      end
    else
      Person.has_committee.committee(cmte).valid_email
    end
  end

  def generate_email_hash
    self.email_hash = self.class.generate_hash(self.EmailAddress)
    save(validate: false)
  end

  def self.to_csv
    people = Person.active.where(MemberType: [ "Member", "Partner" ]).order("memberships.LastName")
    CSV.generate(col_sep: ",") do |csv|
      csv << %w[FirstName LastName MemberLastName MailingName Status Comittee MemberSince MemberType Birthyear]
      people.each do |p|
        m = p.membership
        csv << [ p.FirstName, p.LastName, m.LastName, m.MailingName, m.Status, p.Committee1, m.MemberSince, p.MemberType, p.BirthYear ]
      end
    end
  end

  def self.email_list_to_csv
    people = Person.email_list
    CSV.generate(col_sep: ",") do |csv|
      csv << %w[FirstName LastName Email]
      people.each do |p|
        csv << [ p.FirstName, p.LastName, p.EmailAddress ]
      end
    end
  end

  def self.resigned_to_csv
    people = Person.resigned.where(MemberType: [ "Member", "Partner" ]).order("memberships.LastName")
    CSV.generate(col_sep: ",") do |csv|
      csv << %w[FirstName LastName MemberLastName MailingName Status Comittee MemberSince MemberType Birthyear ResignationDate Updated_at]
      people.each do |p|
        m = p.membership
        csv << [ p.FirstName, p.LastName, m.LastName, m.MailingName, m.Status, p.Committee1, m.MemberSince, p.MemberType, p.BirthYear, m.resignation_date, m.updated_at ]
      end
    end
  end

  def self.committee_spreadsheet(people)
    CSV.generate(col_sep: ",") do |csv|
      csv << %w[FirstName LastName HomePhone WorkPhone CellPhone EmailAddress Committee]
      people.each do |p|
        csv << [ p.LastName, p.FirstName, p.HomePhone, p.WorkPhone, p.CellPhone, p.EmailAddress, p.Committee1 ]
      end
    end
  end

  private_class_method

  def self.generate_hash(str)
    string_to_hash = str + "weeble"
    Digest::SHA1.hexdigest(string_to_hash)
  end
end
