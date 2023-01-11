class ReportsController < ApplicationController

  def summary
    @categories = Membership.select(:Status).group(:Status).count
    @categories.delete("Resigned")
    @categories.delete("Deceased")
    @categories.delete("Affiliated")
    @categories.delete("Non-member")

    @total = @categories.sum { |k,v| v}
  end
  
end
