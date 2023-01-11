class ReportsController < ApplicationController

  def summary
    @categories = Membership.select(:Status).group(:Status).count
    @categories.delete("Resigned")
    @categories.delete("Deceased")
    @categories.delete("Affiliated")
    @categories.delete("Non-member")

    @total = @categories.sum { |k,v| v}
  end

  def history
    @m = Membership.all
    @categories = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = 0} }
    @m.each do |m|
      if m.Status == "Accepted"
        date = m.created_at
      elsif m.Status == "Active"
        date = m.active_date
      elsif m.Status == "Resigned"
        date = m.resignation_date || m.updated_at
      else
        date = m.change_status_date
      end
      if date && date.year > 2018
        month_year = date.strftime('%Y')  # %Y-%m for year & month
        m.Status = "Resigned" if m.Status == "Deceased"
        @categories[m.Status][month_year] += 1
      end
    end
    @dates = []
    @categories.keys.each do |status|
      @dates += @categories[status].keys.to_a
    end
    @dates.uniq!
    @dates.sort
  end

end

