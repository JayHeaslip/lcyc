class UnsubscribeController < ApplicationController

  skip_before_action :check_authentication
  skip_before_action :check_authorization

  def show
    @person = Person.find_by_email_hash(params[:id])
    @hash = params[:id]
    if @person
      render 
    else
      flash[:notice] = "Email address not found."
      redirect_to root_path
    end
  end

  def update
    @person = Person.find_by_email_hash(params[:id])
    @person.subscribe_general = false
    if @person.save(:validate => false)
      flash[:notice] = "You have unsubscribed." 
      redirect_to :controller => 'admin', :action => 'index'
    else
      flash[:notice] = "There was a problem unsubscribing."
    end
  end

end
