class Fee < ApplicationRecord
  validates :active, numericality: { only_integer: true }, presence: true
  validates :senior, numericality: { only_integer: true }, presence: true
  validates :associate, numericality: { only_integer: true }, presence: true
  validates :inactive, numericality: { only_integer: true }, presence: true
  validates :mooring_fee, numericality: { only_integer: true }, presence: true
  validates :mooring_replacement_fee, numericality: { only_integer: true }, presence: true
  validates :drysail_fee, numericality: { only_integer: true }, presence: true

  def self.instance
    find(1)
  end
end
