require "csv"

class Boat < ApplicationRecord
  has_and_belongs_to_many :memberships
  belongs_to :mooring, optional: true
  belongs_to :drysail, optional: true

  validate :name_or_mfg?
  validates_uniqueness_of :Name, scope: :Mfg_Size, allow_blank: true
  validates_uniqueness_of :Mfg_Size, scope: :Name, allow_blank: true
  validate :check_location

  scope :active_members, -> { includes(:memberships).where(memberships: { Status: [ "Associate", "Active", "Senior" ] }) }

  def name_or_mfg?
    if self.Name.blank? && self.Mfg_Size.blank?
      errors.add(:base, "You must specify either a Name or Mfg/Size")
    end
  end

  def check_location
    return if new_record?
    if location == "Mooring" && !mooring # no mooring set
      check_mooring
    elsif location == "Parking Lot" && !drysail # no drysail set
      check_drysail
    end
  end

  def selection_string
    name = (self&.Name != "") ? self.Name : "(no name)"
    "#{name} #{self.Mfg_Size}"
  end

  def self.to_csv
    boats = Boat.active_members.order(:Name).includes(:memberships)
    CSV.generate(col_sep: ",") do |csv|
      csv << [ "Name", "Mooring#", "Sail#", "Mfg/Size", "PHRF", "Owner" ]
      boats.each do |b|
        csv << [ b.Name, b.mooring_id, b.sail_num, b.Mfg_Size, b.phrf, b.owners.join("/") ]
      end
    end
  end

  def phrf
    (self.PHRF == 0) ? "" : self.PHRF
  end

  def owners
    memberships.map { |e| e.LastName }.sort!
  end

  private

  def check_mooring
    available_mooring = Membership.mooring_available(memberships)
    if available_mooring
      self.mooring = available_mooring
    else
      self.location = ""
      errors.add(:base, "Mooring not available for boat")
    end
  end

  def check_drysail
    available_drysail = Membership.drysail_available(memberships)
    if available_drysail
      self.drysail = available_drysail
    else
      self.location = ""
      errors.add(:base, "Drysail spot not available for boat")
    end
  end
end
