class PeopleController < ApplicationController

  def show
  end

  def destroy
    Membership.find(params[:membership_id]).people.find(params[:id]).destroy
    flash[:notice] = 'Person was successfully deleted.'
    redirect_to membership_path(params[:membership_id])
  end

end
