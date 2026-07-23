class Fee < ApplicationRecord
  validates :active, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :senior, numericality: { only_integer: true, greater_than: 0  }, presence: true
  validates :associate, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :inactive, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :mooring_fee, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :mooring_replacement_fee, numericality: { only_integer: true, greater_than: 0 }, presence: true
  validates :drysail_fee, numericality: { only_integer: true, greater_than: 0 }, presence: true

  def self.instance
    find(1)
  end
end
