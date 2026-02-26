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

  def role_authorized?
    current_user.roles.detect do |r|
      r.rights.detect do |right|
        right.action == action_name && right.controller == self.class.controller_path
      end
    end
  end
end
