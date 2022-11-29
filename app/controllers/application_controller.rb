class ApplicationController < ActionController::Base
  include Authentication
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :check_authorization, :breadcrumbs

  private

  def check_authorization
    logger.info "Current.user is #{Current.user.email}"
    if Current.user.nil?
      return false
    elsif Current.user.role?('Admin')
      logger.info "Current.user is Admin"
      return true
    else
      logger.info "Roles"
      Current.user.roles.each do |r|
        logger.info r.name
      end
      logger.info "action #{action_name}"
      logger.info "controller #{self.class.controller_path}"
      unless Current.user&.roles.detect do |role|
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
