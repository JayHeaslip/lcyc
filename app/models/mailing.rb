class Mailing < ApplicationRecord

  has_many :attachments
  accepts_nested_attributes_for :attachments, allow_destroy: true
  validates_presence_of     :subject
  
end
