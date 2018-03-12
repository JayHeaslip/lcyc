class AdminController < ApplicationController

  skip_before_action :check_authentication, :session_expiry, except: [:index]
  skip_before_action :check_authorization

  def index
  end

  def login
    self.current_user = nil
    flash[:notice] = "Session expired, please login again" if session[:expired]
    if request.post?
      uri = session[:original_uri]
      self.current_user = User.authenticate(params[:email], params[:password])
      if logged_in?
        session[:expired] = false
        session[:breadcrumbs] = "/"
        flash.delete(:notice)
        if params[:remember_me] == '1'
          self.current_user.remember_me unless self.current_user.remember_token?
          cookies[:auth_token] = { value: self.current_user.remember_token , expires: self.current_user.remember_token_expires_at }
        end
        redirect_to(uri || root_path)
      else
        flash[:error] = "Invalid user/password combination"
        redirect_to login_path
      end
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_to action: "login"
  end

end
