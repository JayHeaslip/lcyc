class Person < ActiveRecord::Base
  belongs_to :membership ## , :foreign_key => 'MembershipID'
  has_one :user
end
