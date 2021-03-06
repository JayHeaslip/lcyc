class PeopleController < ApplicationController

  before_action :get_membership, only: [:destroy]
  before_action :authorize, only: [:destroy]

  def select_committee
  end
  
  def committee
    @committee = params[:committee] || 'Boats'
    @people = Person.active.where(MemberType: ['Member', 'Partner']).committee(@committee).order(:LastName)
  end

  def destroy
    @membership  = Membership.find(params[:membership_id])
    @membership.people.find(params[:id]).destroy
    flash[:notice] = 'Person was successfully deleted.'
    redirect_to membership_path(params[:membership_id])
  end

  private

  def get_membership
    @membership = Membership.find(params[:membership_id])
  end

  def authorize
    if not current_user.roles?(%w(Admin Membership)) #BOG
      if current_user.membership && current_user.membership != params[:membership_id].to_i
        flash[:error] = "You are not authorized to view the page you requested."
        request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to root_path)
        return false
      else
        return true
      end
    else
      return true  #Admin & Membership
    end
  end

end
