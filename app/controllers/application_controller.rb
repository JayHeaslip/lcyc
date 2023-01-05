class ApplicationController < ActionController::Base
  include Authentication
  
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :check_authorization

  private

  def check_authorization
    if current_user.admin?
      true
    else
      roles = [Current.user.role]
      # at most, 2 levels of hierarchy in the roles
      roles << Current.user.role.parent if Current.user.role.parent
      detect = roles.detect do |r|
        r.rights.detect do |right|
          right.action == action_name && right.controller == self.class.controller_path
        end
      end
      unless roles.detect do |r|
               r.rights.detect do |right|
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
