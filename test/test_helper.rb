require "simplecov"
SimpleCov.start "rails"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/config/"
    add_filter "/lib/"
    add_filter "/vendor/"

    add_group "Controllers", "app/controllers"
    add_group "Models", "app/models"
    add_group "Helpers", "app/helpers"
    add_group "Mailers", "app/mailers"
    add_group "Views", "app/views"
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  def current_user
    if session[:current_active_session_id].present?
      ActiveSession.find_by(id: session[:current_active_session_id])&.user
    else
      cookies[:remember_token].present?
      ActiveSession.find_by(remember_token: cookies[:remember_token])&.user
    end
  end

  def login(user, remember_user: nil)
    post login_path, params: {
      email: user.email,
      password: user.password,
      remember_me: (remember_user == true) ? 1 : 0
    }
  end

  def logout
    session.delete(:current_active_session_id)
  end
end

class ActionDispatch::IntegrationTest
  def login_as(user, password)
    post login_url, params: { email: user.email, password: password }
  end

  def logout
    delete logout_path
  end
end
