class BoatsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @boats = Boat.active_members.order("#{sort_column} #{sort_direction}")
  end

  def show
    @boat = Boat.find(params[:id])
  end

  def edit
    @boat = Boat.find(params[:id])
  end

  def update
    @boat = Boat.includes(:memberships).find(params[:id])
    @boat.attributes = boat_params
    if @boat.save
      flash[:notice] = "Successfully updated boat."
      redirect_to boat_path(@boat)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @boat = Boat.find(params[:id])
    logger.info "deleting boat"
    unless adjust_membership
      flash[:notice] = "Boat deleted."
      @boat.delete
    end
    redirect_to request.referer
  end

  def rmboat
    @boat = Boat.find(params[:id])
    @membership = Membership.find(params[:membership_id])
    # if the membership has the mooring the boat is on
    # remove the boat from the mooring
    if @membership.mooring && (@membership.mooring.id == @boat.mooring_id)
      @boat.location = ""
      @boat_mooring_id = nil
    end
    @boat.memberships.delete(@membership)
    flash[:notice] = "#{@membership.LastName} removed from boat"
    if @boat.memberships.empty?
      flash[:notice] += ", boat deleted."
      @boat.destroy
    end
    redirect_to request.referer
  end

  def associate
    @boat = Boat.find(params[:id])
    @memberships = Membership.active - @boat.memberships
  end

  def save_association
    @boat = Boat.find(params[:id])
    adjust_boat_membership
    if @boat.save
      flash[:notice] = "Saved association."
      redirect_to boat_path(@boat)
    else
      # :nocov:
      @memberships = Membership.active - @boat.memberships
      render :associate, status: :unprocessable_entity
      # :nocov:
    end
  end

  private

  def sort_column
    Boat.column_names.include?(params[:sort]) ? params[:sort] : "Name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def boat_params
    params.require(:boat).permit(:Mfg_Size, :Type, :Name, :Length,
                                 :Draft, :Class, :PHRF, :sail_num, :Status, :location, :mooring_id)
  end

  def adjust_membership
    return unless @boat.memberships.size > 1

    @membership = Membership.find(params[:membership_id])
    @membership.boats = @membership.boats - [ @boat ]
    @membership.save
  end

  def adjust_boat_membership
    @membership = Membership.find(params[:boat][:memberships])
    @boat.memberships << @membership
    @membership.mooring = @boat.mooring if @boat.location == "Mooring"
  end
end
