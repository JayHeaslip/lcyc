class DrysailsController < ApplicationController
  def assign
    @drysail = Drysail.find(params[:id])
    @memberships = Membership.active - Drysail.memberships
  end

  def index
    @drysails = Drysail.order(:id)
  end

  def update
    @drysail = Drysail.find(params[:id])
    @drysail.membership = Membership.find(params[:membership])
    if @drysail.save
      flash[:success] = "Assigned dry sail spot ##{@drysail.id}."
      redirect_to drysails_path
    else
      flash.now[:alert] = "Problem assiging dry sail spot"
      render :assign, status: :unprocessable_entity
    end
  end
end
