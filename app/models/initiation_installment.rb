class InitiationInstallment < ApplicationRecord
  belongs_to :membership, optional: true

  validates :amount, numericality: { only_integer: true }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: Time.now.year - 5, less_than: Time.now.year + 10 }
end
