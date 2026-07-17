class ActiveSessionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :check_authorization

  def index
    @active_sessions = ActiveSession.all
  end

  def destroy
    @active_session = ActiveSession.find(params[:id])
    user = @active_session.user
    @active_session.destroy
    redirect_to params[:redirect_to] || edit_user_path(user), notice: "Session deleted."
  end
end
