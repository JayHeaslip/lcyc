class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  skip_before_action :authenticate_user!
  skip_before_action :check_authorization

  def new
    @user = User.new
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)
    if @user.present? && @user.unconfirmed?
      if @user.confirm!
        redirect_to login_path, notice: "Your account has been confirmed."
      else
        # :nocov:
        redirect_to new_confirmation_path, alert: "Something went wrong."
        # :nocov:
      end
    else
      redirect_to new_confirmation_path, alert: "Invalid token."
    end
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to login_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to new_confirmation_path,
                  alert: "We could not find an user with that email or that email has already been confirmed."
    end
  end
end
