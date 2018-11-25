
class MailingsController < ApplicationController

  skip_before_action :check_authentication, :check_authorization, only: [:deliver_mail]
  
  def index
    @mailings = Mailing.sorted
  end

  def show
    @mailing = Mailing.find(params[:id])
    @test = true
    @filter_emails = false
    check_delayed_job
  end

  def new
    @mailing = Mailing.new
    @mailing.replyto = current_user.email
    @mailing.html = true
    @committees = ['All'].concat(Committee.names)
    check_delayed_job
  end

  def create
    @mailing = Mailing.new(mailing_params)
    @committees = ['All'].concat(Committee.names)
    if @mailing.save
      flash[:notice] = "Success."
      redirect_to mailing_path(@mailing)
    else
      render :new
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
      flash[:notice] = "Success."
      redirect_to mailing_path(@mailing)
    else
      @committees = ['All'].concat(Committee.names)
      render :edit
    end
  end

  def destroy
    Mailing.destroy(params[:id])
    redirect_to mailings_path
  end

  def billing
    @test = true
    check_delayed_job
  end

  def send_bills
    flashes = ""
    replyto = current_user.email
    if params[:test]
      p = Person.find_by_EmailAddress(current_user.email)
      members = [p.membership]
    else
      members = Membership.members.where('Status != "Honorary"').includes(:people)
    end

    members.each_with_index do |m, i|
      logger.info "Generating bill for #{m.MailingName}"
      dues = Membership.dues(m)
      mooring_fees = drysail_fee = 0
      mooring_fees = 200 if (m.mooring_num && m.mooring_num != "" && !m.skip_mooring)
      drysail_fee = 100 if (m.drysail_num && m.drysail_num != "")
      initiation = m.calculate_initiation_installment
      initiation = 0 if initiation.nil?
      member = m.people.where('MemberType = "Member"').first
      email = nil
      if member.EmailAddress && member.EmailAddress != ""
        email = member.EmailAddress
      else
        partner = m.people.where('MemberType = "Partner"').first
        if partner && partner.EmailAddress && partner.EmailAddress != ""
          email = partner.EmailAddress
        end
      end

      if email.nil?
        logger.info "Note: bill was not sent for #{m.MailingName}, no valid email"
        flashes += "Note: bill was not sent for #{m.MailingName}, no valid email<br/>"
      elsif m.paid
        logger.info "#{m.MailingName} was marked as paid"
      else
        if Rails.env == 'development' || Rails.env == 'test'
          MailRobot.send_bills(email, replyto,
                               m.MailingName, m.StreetAddress, m.City, m.State, m.Zip,
                               m.Status, m.mooring_num, m.drysail_num, dues, mooring_fees, drysail_fee, initiation).deliver
        else
          MailRobot.delay(run_at: i.minutes.from_now).send_bills(email, replyto,
                                                                 m.MailingName, m.StreetAddress, m.City, m.State, m.Zip,
                                                                 m.Status, m.mooring_num, m.drysail_num, dues, mooring_fees, drysail_fee, initiation)
        end
      end
    end
    if flashes != ''
      flash[:notice] = flashes
    else
      flash[:notice] = "Sending bills."
    end
    redirect_to root_path
  end
  
  def send_email
    last_email_sent_time = Mailing.order(sent_at: :desc).first.sent_at
    @mailing = Mailing.find(params[:id])

    # it's been at least 23 hours since we sent a blast
    last_email_sent_time = Time.now - 1.day if last_email_sent_time.nil?
    if params[:test] || (Time.now > (last_email_sent_time + 23.hours))  
      @filter_emails = !params[:filter_emails].nil?
      people = Person.email_list(@mailing.committee, @filter_emails)
      people.each {|e| logger.info "General email: #{e.EmailAddress}" }
      if params[:test]
        p = Person.find_by_EmailAddress(current_user.email)
        if p.nil?
          flash[:error] = "Current user's email not found in membership database"
          people = []
          redirect_to mailings_path
        else
          people = [p]   #,p2]*120
          logger.info "Test email address: #{p.EmailAddress}"
        end
      else
        @mailing.sent_at = Time.now
        @mailing.save
      end
      
      unless people.empty?
        people_ids = people.to_a.map {|p| p.id}
        self.deliver_mail(people_ids, params[:id].to_i, host, @filter_emails)
        flash[:notice] = "Delivering mail."
        redirect_to mailings_path
      end
    else
      formatted_time = (last_email_sent_time+23.hours).strftime("%m/%d/%Y at %I:%M %p")
      flash[:error] = "You've sent a mailing within the last 23 hours, please wait until #{formatted_time} to send an email"
      render :show
    end
  end

  def deliver_mail(people, mailing, host, filtered)
    logger.info "Delivering mail from #{host}"
    people.each_with_index do |id, i|
      begin
        person = Person.find(id)
        person.generate_email_hash if person.email_hash.nil?
	#hr = (i/60)
        if Rails.env == 'development' || Rails.env == 'test'
          MailRobot.mailing(person, mailing, host, filtered).deliver
        else
          MailRobot.delay(run_at: (i*30).seconds.from_now).mailing(person, mailing, host,filtered)
        end
      rescue
        logger.info "Person not found: #{id}"
      end
    end
  end
  
  private

  def host
    request.url.gsub(/mailings.*/,'')
  end

  def mailing_params
    params.require(:mailing).permit(:committee, :subject, :replyto, :body, :html,
                                    attachments_attributes: Attachment.attribute_names.map(&:to_sym).push(:_destroy).push(:pdf))

  end

end
