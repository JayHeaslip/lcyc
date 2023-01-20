class Role < ApplicationRecord

  belongs_to :parent, class_name: "Role", optional: true
  has_many :children, class_name: "Role", foreign_key: "parent_id"
  has_many :users
  has_and_belongs_to_many :rights

  validates_uniqueness_of :name
  validates_presence_of :name

end
