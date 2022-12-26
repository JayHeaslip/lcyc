class Drysail < ApplicationRecord

  belongs_to :membership, optional: true
  has_one :boat

  def self.memberships
    Drysail.select { |e| not e.membership.nil?}.map { |e| e.membership}
  end
  
end
