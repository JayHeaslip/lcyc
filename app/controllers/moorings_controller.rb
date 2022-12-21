class MooringsController < ApplicationController

  def index
    @moorings = Mooring.all
  end

  def unassigned
    @moorings = Mooring.unassigned
  end

end
