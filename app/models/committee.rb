class Committee < ApplicationRecord
  has_many :people

  def self.names
    Committee.order(:Name).map { |c| c.Name }
  end
end
