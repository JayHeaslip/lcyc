class ApplicationController < ActionController::Base
  include Authentication
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :check_authorization, :breadcrumbs

  private

  def check_authorization
    if Current.user.nil?
      flash[:alert] = "Please login."
      redirect_to login_path
      false
    elsif Current.user.role?('Admin')
      true
    else
      unless Current.user&.roles.detect do |role|
               role.rights.detect do |right|
                 right.action == action_name && right.controller == self.class.controller_path
               end
             end
        flash[:alert] = "You are not authorized to view the page you requested."
        redirect_to helpers.back_link(1)
        false
      else
        true
      end
    end
  end

  def pop_back_link
    links = session[:breadcrumbs].split(",")
    links.pop
    session[:breadcrumbs] = links.join(",")
  end
  
  def breadcrumbs
    unless session[:breadcrumbs].nil?
      url = request.path
      if url == "/"
        session[:breadcrumbs] = "/"
      else
        session[:breadcrumbs] = session[:breadcrumbs] + ", " + url
      end
    end
  end
      
end
