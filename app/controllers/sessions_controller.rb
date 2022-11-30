class SessionsController < ApplicationController
  #before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]
  skip_before_action :check_authorization


  def create
    logger.info params
    @user = User.authenticate_by(email: params[:email].downcase, password: params[:password])
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
      else
        after_login_path = session[:user_return_to] || root_path
        active_session = login @user
        remember(active_session) if params[:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to login_path, notice: "Signed out."
  end

  def new
    reset_session
  end
end
