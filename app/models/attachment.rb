class Attachment < ApplicationRecord

  belongs_to :mailing, optional: true

  has_attached_file :pdf
  validates_attachment_content_type :pdf, content_type: 'application/pdf'
  validates_attachment_size :pdf, less_than: 5.megabytes

end
