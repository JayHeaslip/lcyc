class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: [ :destroy ]
  skip_before_action :check_authorization

  def new; end

  def create
    @user = User.authenticate_by(email: params[:email].downcase, password: params[:password])
    if @user
      user_signin
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

  private

  def user_signin
    if @user.unconfirmed?
      redirect_to new_confirmation_path, alert: "Incorrect email or password."
    else
      active_session_signin
    end
  end

  def active_session_signin
    after_login_path = session[:user_return_to] || root_path
    active_session = login @user
    remember(active_session) if params[:remember_me] == "1"
    redirect_to after_login_path, notice: "Signed in."
  end
end
