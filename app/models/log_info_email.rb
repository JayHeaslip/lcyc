class LogInfoEmail < ApplicationRecord
  validates :subject, presence: true
  validates :body, presence: true

  self.table_name = "log_info_email"
end
