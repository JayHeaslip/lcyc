class AdminController < ApplicationController

  skip_before_action :check_authorization
  
  def index
  end

end
