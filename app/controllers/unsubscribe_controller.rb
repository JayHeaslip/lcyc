class UnsubscribeController < ApplicationController

  skip_before_action :authenticate_user!
  skip_before_action :check_authorization

  def update
    @person = Person.find_by_email_hash(params[:id])
    @person.subscribe_general = false
    if @person.save(:validate => false)
      flash[:notice] = "You have unsubscribed." 
      redirect_to root_path
    else
      flash[:alert] = "There was a problem unsubscribing."
    end
  end

end
