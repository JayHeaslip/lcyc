require 'digest/sha2'

class UsersController < ApplicationController

  before_action :check_authentication, only: [:index, :show, :edit, :update, :destroy, :editpw, :updatepw]
  before_action :check_authorization, only: [:index, :destroy, :rmrole]
  before_action :set_current_user, only: [:show, :edit, :update, :editpw, :updatepw]
  before_action :check_delayed_job, only: [:create, :resend_email, :forgotpw]

  def index
    if params[:role_id]
      @role = Role.find(params[:role_id])
      @users = @role.users.sort_by {|u| u.lastname}
    else
      @role = nil
      @users = User.order(:lastname)
    end
  end

  def show
  end

  def new
    flash[:notice] = "Please use the email that is in the LCYC log so you will be recognized"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.person = Person.find_by_EmailAddress(@user.email)
    if @user.save
      flash[:success] = 'User was successfully created.'
      MailRobot.confirmation_email(@user, @user.get_confirmation_hash, host).deliver
      redirect_to registration_info_user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.role_ids = params[:role_ids] if current_user.role?('Admin')
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      if current_user.role?('Admin')
        redirect_to users_path
      else
        redirect_to user_path(@user)
      end
    else
      render :edit
    end
  end

  def destroy
    u = User.find(params[:id])
    flash[:notice] = "Removed #{u.email}"
    u.destroy
    redirect_to users_path
  end

  def registration_info
    @user = User.find(params[:id])
  end

  def resend_email
    @user = User.find(params[:id])
    MailRobot.confirmation_email(@user,  @user.get_confirmation_hash, host).deliver
    flash[:success] = "Confirmation email was resent."
    redirect_to registration_info_user_path(@user)
  end

  # confirm an email address
  def confirm_email
    # if the passed hash matches up with a User, confirm
    @user = User.find_by_confirmation_hash(params[:hash])
    if @user
      @user.email_confirmed = true
      @user.confirmation_hash = nil
      @user.save(validate: false)
      flash[:success] = "Thank you for validating your email."
    else
      flash[:error] = "User not found."
    end
    redirect_to login_path
  end

  def editpw
  end

  def updatepw
    @user = User.authenticate(current_user.email, params[:old_password])
    if @user
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      if @user.save
        flash[:success] = "Password Updated."
        redirect_to helpers.back_link(2)
      else
        pop_back_link
        render :editpw
      end
    else
      @user = current_user
      flash.now[:error] = "Incorrect old password"
      pop_back_link
      render :editpw
    end
  end

  def forgotpw
    @user = User.new
    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user
        if not @user.email_confirmed
          flash[:success] = "Please confirm your account before trying to reset your password."
          redirect_to registration_info_user_path(@user)
        else
          @user.reset_password_code_until = 1.day.from_now
          @user.reset_password_code = Digest::SHA256.hexdigest("#{@user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}")
          @user.save!
          MailRobot.newpw_email(@user, host).deliver
          flash[:success] = "A link has been mailed to you to allow you to reset your password."
          redirect_to login_path
        end
      else
        @user = User.new
        flash.now[:error] = "Email address not found."
        render 
      end
    end
  end

  #reset password
  def rp
    @user = User.find_by_reset_password_code(params[:hash])
    if request.patch?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      @user.reset_password_code = nil
      if @user.save
        flash[:success] = "Your password has been updated."
        redirect_to login_path
      else
        render
      end
    else # get request
      if @user && @user.reset_password_code_until && Time.now < @user.reset_password_code_until
        render
      else
        flash[:error] = "Not found, link may have expired."
        redirect_to forgotpw_users_path
      end
    end
  end

  def rmrole
    @role = Role.find(params[:role_id])
    @user = User.find(params[:id])
    @role.users.delete(@user)
    flash[:success] = "#{@user.firstname} #{@user.lastname} removed from #{@role.name}."
    redirect_to roles_path
  end

  private

  def set_current_user
    if current_user.role?('Admin')
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def host
    request.url.gsub(/users.*/,'')
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email,
                                 :password, :password_confirmation)
  end
end
