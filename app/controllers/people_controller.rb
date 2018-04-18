class PeopleController < ApplicationController

  skip_before_action :check_authentication, :only => [ :unsubscribe ]
  skip_before_action :check_authorization,  :only => [ :unsubscribe ]
  before_action :get_membership, :except => [:unsubscribe, :committee]
  before_action :authorize, :except => [:committee, :unsubscribe]

  def committee
    @committee = params[:committee] || 'Boats'
    @people = Person.active.committee(@committee).order(:LastName)
  end

  def unsubscribe
    @person = Person.find_by_email_hash(params[:hash])
    @hash = params[:hash]
    if @person
      @person.subscribe_general = false
      if @person.save(validate: false)
        flash[:notice] = "You have unsubscribed." 
      else
        flash[:notice] = "There was a problem unsubscribing."
      end
      redirect_to root_path
    else
      flash[:notice] = "Email address not found."
      redirect_to root_path
    end
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
