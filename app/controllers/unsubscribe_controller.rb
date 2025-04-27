class UnsubscribeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_authorization

  def show
    @hash = params[:id]
  end
  
  def update
    @person = Person.find_by_email_hash(params[:id])
    if @person
      @person.subscribe_general = false
      if @person.save(validate: false)
        flash[:notice] = "You have unsubscribed."
      else
        # :nocov:
        flash[:alert] = "There was a problem unsubscribing."
        # :nocov:
      end
    else
      flash[:alert] = "Email address not found."
    end
    redirect_to root_path
  end
end
