class BoatsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_action :get_membership, except: [:index, :associate, :save_association]
  before_action :authorize, except: [:index, :associate, :save_association]

  def index
    @boats = Boat.order(sort_column + " " + sort_direction)
  end

  def show
    @boat = Boat.find(params[:id])
  end

  def destroy
    @boat = Boat.find(params[:id])
    if @membership
      @membership.boats.delete(@boat)
      @boat.destroy if @boat.memberships.empty?
    else
      @boat.destroy
    end
    redirect_to @membership ? membership_path(@membership) : boats_path
  end

  def edit
    @boat = Boat.find(params[:id])
  end

  def update
    @boat = Boat.find(params[:id])
    @boat.attributes = boat_params
    if @boat.save
      flash[:notice] = "Successfully updated boat."
      redirect_to boat_path(@boat)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def associate
    @boat = Boat.find(params[:id])
    @memberships = Membership.active - @boat.memberships
  end

  def save_association
    @boat = Boat.find(params[:id])
    @boat.memberships << Membership.find(params[:boat][:memberships].to_i)
    if @boat.save
      redirect_to boat_path(@boat)
    else
      @memberships = Membership.active - @boat.memberships
      puts @boat.errors.full_messages
      render :associate, status: :unprocessable_entity
    end
  end

  private

  def get_membership
    if params[:membership_id]  
      @membership = Membership.includes(:boats).find(params[:membership_id])
      @authorized_memberships = [@membership]
    else
      @membership = nil
      @authorized_memberships = Boat.find(params[:id]).memberships
    end
  end

  def authorize
    if not current_user.roles?(%w(Admin Membership Harbormaster)) 
      if @authorized_memberships.map {|m| m.id}.include?(current_user.membership)
        return true
      else
        flash[:error] = "You are not authorized to view the page you requested."
        request.env["HTTP_REFERER" ] ? (redirect_to :back) : (redirect_to root_path)
        return false
      end
    else
      return true  #Admin/Membership/Harbormaster
    end
  end

  def sort_column
    Boat.column_names.include?(params[:sort]) ? params[:sort] : "Name"
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

  def boat_params
    params.require(:boat).permit(:Mfg_Size, :Type, :Name, :Length,
                                 :Draft, :Class, :PHRF, :sail_num, :Status, :location, :mooring)
  end
  
end
