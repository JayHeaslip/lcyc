class Mailing < ApplicationRecord

  has_many :attachments
  accepts_nested_attributes_for :attachments, allow_destroy: true
  validates_presence_of     :subject

  scope :nulls_first, -> { order("sent_at IS NOT NULL") }
  scope :sorted, -> { nulls_first.order(sent_at: :desc, created_at: :desc) }
  
end
