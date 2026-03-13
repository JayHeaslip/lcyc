class LogInfoMailer < ApplicationMailer
  def mailing(membership_id, url_options)
    ActiveStorage::Current.url_options = url_options

    @membership  = Membership.find(membership_id)
    @to, @cc = to_cc

    log_info_email = LogInfoEmail.find(1)

    @subject = log_info_email.subject
    @body = log_info_email.body

    @boat = @membership.boat_info
    @member = @membership.member_info
    @partner = @membership.partner_info[0].split("\t")
    @children = @membership.children_info

    if @to
      mail(to: @to,
           cc: @cc,
           from: "LCYC Announcements <lcyc@members.lcyc.info>",
           reply_to: "lcycsecretary@gmail.com",
           subject: @subject)
    end
  end

  def to_cc
    to = @membership.people.where('MemberType = "Member"').first&.EmailAddress
    cc = @membership.people.where('MemberType = "Partner"').first&.EmailAddress
    if to.nil?
      to = cc
      cc = nil
    end
    [ to, cc ]
  end
end
