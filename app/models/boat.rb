require 'csv'

class Boat < ApplicationRecord

  has_and_belongs_to_many :memberships

  validate :name_or_mfg?
  validate :mooring
  validates_uniqueness_of :Name, scope: :Mfg_Size, allow_blank: true
  validates_uniqueness_of :Mfg_Size, scope: :Name, allow_blank: true 

  def name_or_mfg?
    if self.Name.blank? and self.Mfg_Size.blank?
      errors.add(:base, "You must specify either a Name or Mfg/Size")
    end
  end
  
  # make sure mooring assigned to boat belongs to one of the boat memberships
  def mooring
    errors.add(:base, "Mooring does not belong to any of the boat owners") if !valid_mooring?
  end

  def selection_string
    name = (self.Name && self.Name != '') ? self.Name : "(no name)"
    [name, self.Mfg_Size].join(" ")
  end
  
  def self.to_csv
    boats = Boat.order('Name, mooring_num').includes(:memberships)
    CSV.generate(col_sep: ",") do |csv|
      csv << ['Name', 'Mooring#', 'Sail#', 'Mfg/Size', 'PHRF', 'Owner']
      boats.each do |b|
        phrf = b.PHRF == 0 ? '' : b.PHRF
        owners = b.memberships.map {|e| e.LastName}.sort!
        csv << [b.Name, b.mooring_num, b.sail_num, b.Mfg_Size, phrf, owners.join("/")]
      end
    end
  end

  private

  def valid_mooring?
    valid_moorings = self.memberships.map {|m| m.mooring_num}
    if self.mooring_num and not valid_moorings.include?(self.mooring_num)
      return false
    else
      return true
    end
  end
  
end
