require 'csv'

class Boat < ApplicationRecord

  has_and_belongs_to_many :memberships

  validate :name_or_mfg?
  validate :mooring

  def name_or_mfg?
    if self.Name.blank? and self.Mfg_Size.blank?
      errors.add(:base, "You must specify either a Name or Mfg/Size")
    end
  end
  
  # make sure mooring assigned to boat belongs to one of the boat memberships
  def mooring
    valid_moorings = self.memberships.map {|m| m.mooring_num}
    if self.mooring_num and not valid_moorings.include?(self.mooring_num)
      errors.add(:base, "Mooring does not belong to any of the boat owners")
    end
  end

  def selection_string
    if self.Name && self.Name != ''
      name = self.Name
    else 
      name = "(no name)"
    end
    [name, self.Mfg_Size].join(" ")
  end
  
  def self.to_csv
    boats = Boat.order('Name, mooring_num').includes(:memberships)
    valid_moored_boats = []
    CSV.generate(col_sep: "\t") do |tsv|
      tsv << ['Name', 'Mooring#', 'Sail#', 'Mfg/Size', 'PHRF', 'Owner']
      boats.each do |b|
        phrf = b.PHRF == 0 ? '' : b.PHRF
        owners = []
        found = false
        b.memberships.each do |m|
          #ensure that mooring # for boat is valid
          #mooring # must belong to one of the owners
          if m.mooring_num and not found and b.mooring_num == m.mooring_num
            found = true
            valid_moored_boats << b
          end
          owners << m.LastName
        end
        logger.info "boat not on owners mooring: #{b.Name}, #{b.Mfg_Size}" if not found
        owners.sort!
        owner_str = owners.join("/")
        tsv << [b.Name, b.mooring_num, b.sail_num, b.Mfg_Size, phrf, owner_str]
      end
    end
  end

end
