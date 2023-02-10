class ReportsController < ApplicationController
  def summary
    @categories = Membership.select(:Status).group(:Status).count
    @categories.delete("Resigned")
    @categories.delete("Deceased")
    @categories.delete("Affiliated")
    @categories.delete("Non-member")

    @total = @categories.sum { |k, v| v }
  end

  def history
    @m = Membership.all
    @categories = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = 0 } }
    @m.each do |m|
      date = if m.Status == "Accepted"
        m.created_at
      elsif m.Status == "Active"
        m.active_date
      elsif m.Status == "Resigned"
        m.resignation_date || m.updated_at
      else
        m.change_status_date
      end
      if date && date.year > 2018
        month_year = date.strftime("%Y")  # %Y-%m for year & month
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

  def moorings
    moorings = Mooring.all

    @unassigned = []
    @skip_errors = []
    @multiple_memberships = []
    moorings.each do |m|
      memberships = m.memberships
      if memberships.empty?
        @unassigned << m.id
      elsif memberships.size > 1
        @multiple_memberships << m.id
        skip_count = 0
        memberships.each do |m|
          skip_count += 1 if m.skip_mooring
        end
        @skip_errors << m.id unless (skip_count + 1) == memberships.size
      elsif memberships[0].skip_mooring
        @skip_errors << m.id
      end
    end
  end
end
