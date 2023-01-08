
class MailingsController < ApplicationController
  include ActiveStorage::SetCurrent
  
  skip_before_action :authenticate_user!, :check_authorization, only: [:deliver_mail]
  before_action :check_delayed_job, only: [:new, :show, :loginfo]
  
  def index
    @mailings = Mailing.sorted
  end

  def show
    @mailing = Mailing.find(params[:id])
    @test = true
    @filter_emails = false
  end

  def new
    @mailing = Mailing.new
    @mailing.replyto = Current.user.email
    @mailing.html = true
    @committees = ['All'].concat(Committee.names)
  end

  def create
    @mailing = Mailing.new(mailing_params)
    @committees = ['All'].concat(Committee.names)
    if @mailing.save
      flash[:success] = "Success."
      redirect_to mailing_path(@mailing)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @mailing = Mailing.find(params[:id])
    @committees = ['All'].concat(Committee.names)
  end

  def update
    @mailing = Mailing.find(params[:id])
    @mailing.attributes = mailing_params
    if @mailing.save
      flash[:success] = "Success."
      redirect_to mailing_path(@mailing)
    else
      @committees = ['All'].concat(Committee.names)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Mailing.destroy(params[:id])
    redirect_to mailings_path
  end

  def loginfo
    @membership_chair = session[:membership_chair]
    if request.post?
      if params[:membership_chair].blank?
        flash.now[:error] = "Membership chair cannot be blank."
        @m = Membership.find(407)
        @boat_info = @m.boat_info
        @member_info = @m.member_info
        @partner_info = @m.partner_info[0].split("\t")
        @children_info = @m.children_info
        render :loginfo, status: :unprocessable_entity
      else
        session[:membership_chair] = params[:membership_chair]
        if params[:test]
          memberships = [Membership.find(407)]
        else
          memberships = Membership.member
        end
        memberships.each_with_index do |m, i|
          if params[:test]
            to = Current.user.email
            cc = nil
          else
            to = m.people.where('MemberType = "Member"').EmailAddress.first
            cc = m.people.where('MemberType = "Partner"').EmailAddress.first
          end
          partner_info = m.partner_info[0].split("\t")
          MailRobot.loginfo(ActiveStorage::Current.url_options, to, cc, @membership_chair, m,
                            m.boat_info, m.member_info, partner_info, m.children_info).deliver_later(wait_until: (i*30).seconds.from_now)
        end
        flash[:notice] = "Log info emails sent."
        redirect_to root_url
      end
    else
      @m = Membership.find(407)
      @boat_info = @m.boat_info
      @member_info = @m.member_info
      @partner_info = @m.partner_info[0].split("\t")
      @children_info = @m.children_info
      session[:referrer] = request.referrer
    end
  end

  
  def send_email
    @mailing = Mailing.find(params[:id])

    # check if it's been at least 23 hours since we sent a blast
    last_email_sent_time = Mailing.order(sent_at: :desc).first.sent_at
    last_email_sent_time = Time.now - 1.day if last_email_sent_time.nil?

    if params[:test] || (Time.now > (last_email_sent_time + 23.hours))  
      @filter_emails = !params[:filter_emails].nil?
      people = Person.email_list(@mailing.committee, @filter_emails)
      people.each {|e| logger.info "General email: #{e.EmailAddress}" }
      if params[:test]
        p = Person.find_by_EmailAddress(Current.user.email)
        if p.nil?
          p = add_as_nonmember(Current.user.email)
        end
        people = [p]
        logger.info "Test email address: #{p.EmailAddress}"
      else
        @mailing.sent_at = Time.now
        @mailing.save
      end

      unless people.empty?
        deliver_mail(people, @mailing, host, @filter_emails)
        flash[:notice] = "Delivering mail."
        redirect_to mailings_path
      end
    else
      formatted_time = (last_email_sent_time+23.hours).strftime("%m/%d/%Y at %I:%M %p")
      flash[:error] = "You've sent a mailing within the last 23 hours, please wait until #{formatted_time} to send an email"
      render :show, status: :unprocessable_entity
    end
  end

  def deliver_mail(people, mailing, host, filtered)
    people.each_with_index do |person, i|
      person.generate_email_hash if person.email_hash.nil?
      if Rails.env == 'test'
        MailRobot.mailing(ActiveStorage::Current.url_options, person, mailing, host, filtered).deliver
      else
        MailRobot.mailing(ActiveStorage::Current.url_options, person, mailing, host, filtered).deliver_later(wait_until: (i*30).seconds.from_now)
      end
    end
  end
  
  private

  def host
    request.url.gsub(/mailings.*/,'')
  end

  def mailing_params
    params.require(:mailing).permit(:committee, :subject, :replyto, :content)

  end

  def add_as_nonmember(email)
    m = Membership.where(Status: 'Non-member').first
    if m.nil?
      m = Membership.new(Status: 'Non-member')
      m.save(validate: false)
    end
    p = Person.new(EmailAddress: email,
                 subscribe_general: false,
                 MemberType: 'MailList',
                 MembershipID: m.id)
    p.save(validate: false)
    return p
  end
end
