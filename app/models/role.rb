class Role < ApplicationRecord

  has_and_belongs_to_many :users
  has_and_belongs_to_many :rights

  validates_uniqueness_of :name
  validates_presence_of :name

end
