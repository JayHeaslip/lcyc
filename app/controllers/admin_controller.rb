class AdminController < ApplicationController

  def index
  end

  def login
    self.current_user = nil

    if request.post?
      uri = session[:original_uri]
      self.current_user = User.authenticate(params[:email], params[:password])
      if logged_in?
        session[:breadcrumbs] = "/"
        flash.delete(:notice)
        if params[:remember_me] == '1'
          self.current_user.remember_me unless self.current_user.remember_token?
          cookies[:auth_token] = { value: self.current_user.remember_token , expires: self.current_user.remember_token_expires_at }
          logger.info "remember token expires at #{self.current_user.remember_token_expires_at}"
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
