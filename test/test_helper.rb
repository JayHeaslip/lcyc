require 'simplecov'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Views', 'app/views'
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def login_as(user, password)
    post login_url, params: { email: user.email, password: password }
  end

  def logout
    delete logout_url
  end

end
