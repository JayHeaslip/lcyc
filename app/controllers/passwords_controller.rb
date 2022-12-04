class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated, except: [:change]
  skip_before_action :authenticate_user!, except: [:change]
  skip_before_action :check_authorization

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to login_path, notice: "If that user exists we've sent instructions to their email."
      else
        redirect_to new_confirmation_path, alert: "Please confirm your email first."
      end
    else
      redirect_to login_path, notice: "If that user exists we've sent instructions to their email."
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: "You must confirm your email before you can sign in."
    elsif @user.nil?
      redirect_to new_password_path, alert: "Invalid or expired token."
    end
  end

  def new
  end

  def change
    @user = Current.user
    if request.post?
      if User.authenticate_by(email: @user.email, password: params[:current_password])
        if @user.update(password_params)
          flash[:success] = "Password updated"
          redirect_to helpers.back_link(1)
        else
          flash.now[:alert] = @user.errors.full_messages.to_sentence
          render :change, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Incorrect current password"
        render :change, status: :unprocessable_entity
      end
    end
  end
  
  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "You must confirm your email before you can sign in."
      elsif @user.update(password_params)
        redirect_to login_path, notice: "Please sign in."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid or expired token."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.permit(:password, :password_confirmation)
  end
end
