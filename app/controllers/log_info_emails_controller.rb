class LogInfoEmailsController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :check_delayed_job, only: [ :edit ]

  # initial email is initialized from db/seeds.rb
  def edit
    @log_info_email = LogInfoEmail.find(1)
    set_loginfo_variables
  end

  def update
    @log_info_email = LogInfoEmail.find(1)
    if @log_info_email.update(log_info_email_params)
      send_emails
      flash[:notice] = "Log info emails sent."
      redirect_to root_url
    else
      set_loginfo_variables
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def log_info_email_params
    params.require(:log_info_email).permit(:subject, :body)
  end

  def set_loginfo_variables
    @m = Person.find_by(EmailAddress: current_user.email&.membership)
    @m = Membership.find(407) if @m.nil?
    @boat_info = @m.boat_info
    @member_info = @m.member_info
    @partner_info = @m.partner_info[0].split("\t")
    @children_info = @m.children_info
    @test = true
  end

  def memberships
    if params[:log_info_email][:test]
      memberships = [ Person.find_by(EmailAddress: current_user.email&.membership) ]
      [ Membership.find(407) ] if memberships[0].nil?
    else
      Membership.members
    end
  end

  def to_cc
    if params[:log_info_email][:test]
      @cc = nil
      @to = current_user.email
    else
      @to = m.people.where('MemberType = "Member"').first.EmailAddress
      @cc = m.people.where('MemberType = "Partner"').first&.EmailAddress
      nil if @to.nil? && @cc.nil?
    end
  end

  def send_emails
    memberships.each_with_index do |m, i|
      if to_cc
        send_email(i)
      else
        logger.info "Log info email not sent for #{m.MailingName}"
      end
    end
  end

  def send_email(cnt)
    partner_info = m.partner_info[0].split("\t")
    member_info = [ @to, @cc, @membership_chair, m, m.boat_info, m.member_info, partner_info, m.children_info ]
    send_time = (cnt * 30).seconds.from_now
    MailRobot.loginfo(ActiveStorage::Current.url_options, member_info).deliver_later(wait_until: send_time)
  end
end
