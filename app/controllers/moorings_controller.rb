class MooringsController < ApplicationController

  helper_method :sort_column, :sort_direction

  def index
    @moorings = Mooring.order(sort_column + " " + sort_direction)
  end

  def unassigned
    @moorings = Mooring.unassigned
  end

  private
  
  def sort_column
    Mooring.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

end
