class LogInfoEmailsController < ApplicationController
  include ActiveStorage::SetCurrent

  # initial email is initialized from db/seeds.rb
  def edit
    @log_info_email = LogInfoEmail.find(1)
    set_loginfo_variables
  end

  def update
    @log_info_email = LogInfoEmail.find(1)
    if @log_info_email.update(log_info_email_params)
      SendBulkLoginfoJob.perform_later(membership_ids, ActiveStorage::Current.url_options)
      flash[:notice] = "Log info emails sent."
      redirect_to root_url
    else
      # :nocov:
      set_loginfo_variables
      render :edit, status: :unprocessable_entity
      # :nocov:
    end
  end

  private

  def log_info_email_params
    params.require(:log_info_email).permit(:subject, :body)
  end

  def set_loginfo_variables
    @m = Person.find_by(EmailAddress: current_user.email).membership
    @m = Membership.find(407) if @m.nil?
    @boat_info = @m.boat_info
    @member_info = @m.member_info
    @partner_info = @m.partner_info[0].split("\t")
    @children_info = @m.children_info
    @test = true
  end

  def membership_ids
    if params[:log_info_email][:test] == "true"
      membership = [ Person.find_by(EmailAddress: current_user.email)&.membership ]
      if membership[0].nil?
        [407]
      else
        [membership.first.id]
      end
    else
      Membership.members.ids
    end
  end

end
