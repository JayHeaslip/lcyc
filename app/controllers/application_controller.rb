class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_authentication, :check_authorization, :breadcrumbs

  # used in views
  helper_method :logged_in?, :current_user

  # Accesses the current user from the session.  Set it to false if login fails
  # so that future calls do not hit the database. current_user is initially "nil"
  def current_user
    @current_user ||= (login_from_session || login_from_cookie) unless @current_user == false
  end

  def current_user=(new_user)
    session[:user] = new_user ? new_user.id : nil
    session[:email] = new_user ? new_user.email : nil
    @current_user = new_user || false
    logger.info "setting current user to #{@current_user.email}" if @current_user
  end

  def logged_in?
    # not nil and not false
    !!current_user
  end

  private

  def login_from_session
    logger.info "logging in from session, sesssion[:user] = #{session[:user]}"
    self.current_user = User.find(session[:user]) if session[:user]
  end

  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      logger.info "logging in from cookie"
      cookies[:auth_token] = { value: user.remember_token, expires: user.remember_token_expires_at }
      self.current_user = user
    else
      logger.info "no current user"
      false
    end
  end

  def check_authentication
    unless current_user
      session[:original_uri] = request.fullpath
      redirect_to login_path
      false
    end
  end

  def check_authorization
    if current_user.role?('Admin')
      return true
    else
      unless current_user.roles.detect do |role|
               role.rights.detect do |right|
                 right.action == action_name && right.controller == self.class.controller_path
               end
             end
        
        flash[:error] = "You are not authorized to view the page you requested."
        redirect_to helpers.back_link(1)
        return false
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

  def check_delayed_job
    begin
      pid = File.open("#{Rails.root}.tmp/pids/delayed_job.pid").readline.chop.to_i
      psout = %x{ps -p #{pid}}
    rescue
      psout = ""
    end
    if Rails.env != "test"
      system("cd #{Rails.root}; RAILS_ENV=#{Rails.env} bundle exec bin/delayed_job start") unless psout.include?('ruby')
    end
  end
      
end
