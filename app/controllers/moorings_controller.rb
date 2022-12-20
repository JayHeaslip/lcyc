class MooringsController < ApplicationController

  def index
    @moorings = Mooring.all
    logger.info "Moorings size #{@moorings.size}"
  end

  def unassigned
    @moorings = Mooring.unassigned
  end

end
