class ActiveSessionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :check_authorization

  def index
    @active_sessions = ActiveSession.all
  end

  def destroy
    @active_session = current_user.active_sessions.find(params[:id])
    @active_session.destroy
    if current_user
      redirect_to user_path(current_user), notice: "Session deleted."
    else
      forget_active_session
      reset_session
      redirect_to root_path, notice: "Signed out."
    end
  end

  def destroy_all
    forget_active_session
    Current.user.active_sessions.destroy_all
    reset_session

    redirect_to root_path, notice: "Signed out."
  end
end
