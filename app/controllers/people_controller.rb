class PeopleController < ApplicationController

  def committee
    @committee = params[:committee] || 'Boats'
    @people = Person.active.committee(@committee).order(:LastName)
  end

  def unsubscribe
    @person = Person.find_by_email_hash(params[:hash])
    @hash = params[:hash]
    if @person
      if request.post?
        @person.subscribe_general = false
        if @person.save(:validate => false)
          flash[:notice] = "You have unsubscribed." 
          redirect_to :controller => 'admin', :action => 'index'
        else
          flash[:notice] = "There was a problem unsubscribing."
        end
      end
    else
      flash[:notice] = "Email address not found."
      redirect_to :controller => 'admin', :action => 'index'
    end
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
