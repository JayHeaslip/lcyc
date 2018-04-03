require 'csv'

class Person < ActiveRecord::Base
  belongs_to :membership, foreign_key: 'MembershipID', optional: true
  has_one :user

  #postgres: column names with upper case need to be quoted
  scope :active, -> { joins(:membership).where("memberships.Status IN ('Active', 'Associate', 'Honorary', 'Life', 'Senior')") }
  scope :committee, ->(cmte) { where(Committee1: cmte) }


  def self.to_csv
    people = Person.active.where(MemberType: ['Member', 'Partner']).order('memberships.LastName')
    CSV.generate(:col_sep => ",") do |tsv|
      tsv << %w(FirstName LastName MemberLastName MailingName Status Comittee MemberSince)
      people.each do |p|
        m = p.membership
        tsv << [p.FirstName, p.LastName, m.LastName, m.MailingName, m.Status, p.Committee1, m.MemberSince]
      end
    end
  end

end
