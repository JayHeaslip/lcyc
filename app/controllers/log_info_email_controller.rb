class LogInfoEmailController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :check_delayed_job, only: [:edit]

  def edit
    @log_info_email = LogInfoEmail.find(1)
    set_loginfo_variables
  end

  def update
    @log_info_email = LogInfoEmail.find(params[:id])
    if @log_info_email.update(log_info_email_params)
      if params[:log_info_email][:test]
        memberships = [Person.find_by_EmailAddress(current_user.email)&.membership]
        memberships = [Membership.find(407)] if memberships[0].nil?
      else
        memberships = Membership.members
      end
      memberships.each_with_index do |m, i|
        if params[:log_info_email][:test]
          to = current_user.email
          cc = nil
        else
          to = m.people.where('MemberType = "Member"').first.EmailAddress
          cc = m.people.where('MemberType = "Partner"').first&.EmailAddress
        end
        if to.nil? && cc.nil?
          logger.info "Log info email not sent for #{m.MailingName}"
        else
          partner_info = m.partner_info[0].split("\t")
          MailRobot.loginfo(ActiveStorage::Current.url_options, to, cc, @membership_chair, m,
            m.boat_info, m.member_info, partner_info, m.children_info).deliver_later(wait_until: (i * 30).seconds.from_now)
        end
      end
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
    @m = Person.find_by_EmailAddress(current_user.email)&.membership
    @m = Membership.find(407) if @m.nil?
    @boat_info = @m.boat_info
    @member_info = @m.member_info
    @partner_info = @m.partner_info[0].split("\t")
    @children_info = @m.children_info
    @test = true
  end
end
