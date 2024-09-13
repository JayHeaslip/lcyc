class Mailing < ApplicationRecord
  has_one_attached :image
  has_many_attached :pdfs
  validate :validate_pdfs

  validates_presence_of :subject
  has_rich_text :content

  scope :nulls_first, -> { order(Arel.sql("sent_at IS NOT NULL")) }
  scope :sorted, -> { nulls_first.order(sent_at: :desc, created_at: :desc) }

  attr_accessor :membership_chair

  private

  def validate_pdfs
    return unless pdfs.attached?

    pdfs.each do |pdf|
      unless pdf.content_type.in?(%w[application/pdf])
        errors.add(:attachments, "must be a PDF")
      end
      unless pdf.byte_size < 5.megabytes
        # :nocov:
        errors.add(:attachments, "must be less than 5 Megabytes")
        # :nocov:
      end
    end
  end
end
