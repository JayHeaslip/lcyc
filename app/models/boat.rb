require 'csv'

class Boat < ApplicationRecord

  has_and_belongs_to_many :memberships
  belongs_to :mooring, optional: true
  belongs_to :drysail, optional: true

  validate :name_or_mfg?
  validates_uniqueness_of :Name, scope: :Mfg_Size, allow_blank: true
  validates_uniqueness_of :Mfg_Size, scope: :Name, allow_blank: true 

  def name_or_mfg?
    if self.Name.blank? and self.Mfg_Size.blank?
      errors.add(:base, "You must specify either a Name or Mfg/Size")
    end
  end
  
  def selection_string
    name = (self.Name && self.Name != '') ? self.Name : "(no name)"
    [name, self.Mfg_Size].join(" ")
  end
  
  def self.to_csv
    boats = Boat.order('Name, mooring_id').includes(:memberships)
    CSV.generate(col_sep: ",") do |csv|
      csv << ['Name', 'Mooring#', 'Sail#', 'Mfg/Size', 'PHRF', 'Owner']
      boats.each do |b|
        phrf = b.PHRF == 0 ? '' : b.PHRF
        owners = b.memberships.map {|e| e.LastName}.sort!
        csv << [b.Name, b.mooring_id, b.sail_num, b.Mfg_Size, phrf, owners.join("/")]
      end
    end
  end

  def update_drysail_and_mooring
    if location == '' || location.nil?
      nil
    elsif location == "Mooring" && mooring.nil?
      available_mooring = Membership.mooring_available(memberships)
      logger.info "available mooring: #{available_mooring.id}"
      if available_mooring
        self.mooring = available_mooring
        nil
      else
        location = ''
        return "Mooring not available for boat.\n"
      end
    elsif location == "Parking Lot" && drysail.nil?
      available_drysail = Membership.drysail_available(memberships)
      if available_drysail
        self.drysail = available_drysail
        nil
      else
        location = ''
        return "Drysail spot not available for boat.\n"
      end
    end
  end

end
