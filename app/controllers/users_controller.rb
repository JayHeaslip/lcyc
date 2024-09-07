class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [ :new, :create ], unless: -> { current_user&.admin? }
  skip_before_action :authenticate_user!, only: [ :new, :create ]
  skip_before_action :check_authorization, only: [ :new, :create ]

  def index
    if params[:role_id]
      @role = Role.find(params[:role_id])
      @users = @role.users.sort_by { |u| u.lastname }
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
    @user.person = Person.find_by_EmailAddress(@user.email)
    @user.role = if @user.person
      Role.find_by_name("Member")
    else
      Role.find_by_name("Non-member")
    end
    update_admin_fields(params)
    if @user.save
      if @user.confirmed_at
        flash[:success] = "User was successfully created."
        redirect_to users_path
      else
        @user.send_confirmation_email!
        redirect_to login_path, notice: "Check your email for confirmation instructions."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = if current_user.admin?
      User.find(params[:id])
    else
      current_user
    end
    @active_sessions = @user.active_sessions.order(created_at: :desc)
  end

  def update
    @user = if current_user.admin?
      User.find(params[:id])
    else
      current_user
    end
    update_admin_fields(params)
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      if current_user.admin?
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
    flash[:success] = "Removed #{u.email}"
    u.destroy
    redirect_to users_path
  end

  def rmrole
    @role = Role.find(params[:role_id])
    @user = User.find(params[:id])
    @role.users.delete(@user)
    flash[:success] = "#{@user.firstname} #{@user.lastname} removed from #{@role.name}."
    redirect_to role_users_path(@role)
  end

  private

  def user_params
    permitted = [ :firstname, :lastname, :email, :password, :password_confirmation ]
    params.require(:user).permit(permitted)
  end

  def update_admin_fields(params)
    if current_user&.admin?
      @user.confirmed_at = Time.now if params[:email_confirmed]
      @user.role = Role.find(params[:user][:role_id])
    end
  end
end
