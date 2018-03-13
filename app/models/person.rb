class Person < ActiveRecord::Base
  belongs_to :membership, foreign_key: 'MembershipID', optional: true
  has_one :user

  scope :active, -> { joins(:membership).where("memberships.Status in ('Active', 'Associate', 'Honorary', 'Life', 'Senior')") }
  scope :committee, ->(cmte) { where(:Committee1 => cmte) }


end
