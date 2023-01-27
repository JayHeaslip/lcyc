class Mooring < ApplicationRecord
  # needed because a mooring may belong to multiple memberships
  has_many :memberships

  has_one :boat

  def self.unassigned
    Mooring.all.select { |e| e.memberships.empty? }
  end
end
