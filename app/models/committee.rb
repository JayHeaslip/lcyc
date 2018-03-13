class Committee < ActiveRecord::Base

  def self.names
    Committee.order(:Name).map {|c| c.Name}
  end

end
