class Person < ActiveRecord::Base
  belongs_to :membership, foreign_key: 'MembershipID', optional: true
  has_one :user
end
