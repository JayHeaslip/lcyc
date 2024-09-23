class ApplicationController < ActionController::Base
  ENV_MAP = { development: 0, staging: 1, production: 2, test: 3 }.freeze
  include Authentication

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :check_authorization

  private

  def check_authorization
    if current_user.admin? || role_authorized?
      true
    else
      flash[:alert] = "You are not authorized to view the page you requested."
      redirect_to request.referer
      false
    end
  end

  def check_delayed_job
    id = ENV_MAP[Rails.env.to_sym]
    begin
      pid = File.open(Rails.root.to_s + "/tmp/pids/delayed_job.#{id}.pid").readline.chop.to_i
      psout = `ps -p #{pid}`
    rescue StandardError
      # :nocov:
      psout = ""
      # :nocov:
    end
    return if psout.include?("ruby")

    # :nocov:
    system("cd #{Rails.root}; RAILS_ENV=#{Rails.env} bundle exec bin/delayed_job -i #{id} start")
    # :nocov:
  end

  def role_authorized?
    current_user.roles.detect do |r|
      r.rights.detect do |right|
        right.action == action_name && right.controller == self.class.controller_path
      end
    end
  end
end
