class DrysailsController < ApplicationController

  def assign
    @drysail = Drysail.find(params[:id])
    @memberships = Membership.active - Drysail.memberships
  end
  
  def update
    membership = Membership.find(params[:membership])
    @drysail = Drysail.find(params[:id])
    @drysail.membership = Membership.find(params[:membership])
    if @drysail.save
      redirect_to drysails_path
    else
      flash[:alert] = "Problem assiging dry sail spot"
      render :assign, status: :unprocessable_entity
    end
  end
  
  def index
    @drysails = Drysail.order(:id)
  end

end
