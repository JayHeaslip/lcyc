class Committee < ApplicationRecord

  def self.names
    Committee.order(:Name).map {|c| c.Name}
  end

end
