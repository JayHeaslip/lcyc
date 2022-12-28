class ApplicationController < ActionController::Base
  include Authentication
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :check_authorization

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
        redirect_to request.referrer
        false
      else
        true
      end
    end
  end

  def check_delayed_job
    begin
      pid = File.open("#{Rails.root}/tmp/pids/delayed_job.pid").readline.chop.to_i
      psout = %x{ps -p #{pid}}
    rescue
      psout = ""
    end
    if Rails.env != "test"
      system("cd #{Rails.root}; RAILS_ENV=#{Rails.env} bundle exec bin/delayed_job start") unless psout.include?('ruby')
    end
  end
  
end
