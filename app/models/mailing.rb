class Mailing < ApplicationRecord

  validates_presence_of :subject
  has_rich_text :content

  scope :nulls_first, -> { order(Arel.sql("sent_at IS NOT NULL")) }
  scope :sorted, -> { nulls_first.order(sent_at: :desc, created_at: :desc) }
  
end
