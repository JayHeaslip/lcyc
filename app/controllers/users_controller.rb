class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:new, :create], unless: -> {Current.user&.admin? }

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
    @user = User.find(params[:id])
  end

  def new
    flash[:notice] = "Please use the email that is in the LCYC log so you will be recognized"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.set_roles(current_user, params[:role_ids])
    @user.person = Person.find_by_EmailAddress(@user.email)
    @user.confirmed_at = Time.now if params[:email_confirmed]
    if @user.save
      flash[:success] = 'User was successfully created.'
      if @user.confirmed_at
        redirect_to users_path
      else
        @user.send_confirmation_email!
        redirect_to registration_info_user_path(@user)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.role_ids = params[:role_ids] if current_user.role?('Admin')
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      if current_user.role?('Admin')
        redirect_to users_path
      else
        redirect_to user_path(@user)
      end
    else
      render :edit, status: :unprocessable_entity
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
    @user.send_confirmation_email!
    flash[:success] = "Confirmation email was resent."
    redirect_to registration_info_user_path(@user)
  end

  def rmrole
    @role = Role.find(params[:role_id])
    @user = User.find(params[:id])
    @role.users.delete(@user)
    flash[:success] = "#{@user.firstname} #{@user.lastname} removed from #{@role.name}."
    redirect_to role_users_path(@role)
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
    permitted = [:firstname, :lastname, :email, :password, :password_confirmation]
    params.require(:user).permit(permitted)
  end
  
end
