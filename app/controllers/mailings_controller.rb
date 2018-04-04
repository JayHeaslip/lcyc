
class MailingsController < ApplicationController

  skip_before_action :check_authentication, :check_authorization, only: [:deliver_mail]
  before_action :check_delayed_job, only: [:show, :new, :billing]
  
  def index
    @mailings = Mailing.order('created_at DESC')
  end

  def show
    @mailing = Mailing.find(params[:id])
    @test = true
  end

  def new
    @mailing = Mailing.new
    @mailing.replyto = current_user.email
    @mailing.html = true
    @committees = ['All'].concat(Committee.names)
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
      render :edit
    end
  end

  def destroy
    Mailing.destroy(params[:id])
    redirect_to mailings_path
  end

  def billing
    @test = true
  end

  def send_bills
    #send_bills(email, replyto, mailingname, email, status, mooring, dues, fees)
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
      dues = Membership.dues(m.Status)
      mooring_maint_fee = fees = 0
      fees = 80 if (m.mooring_num && m.mooring_num != "" && !m.skip_mooring)
      mooring_maint_fee = 120 if (m.mooring_num && m.mooring_num != "" && !m.skip_mooring)
      initiation = m.initiation || 0
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
        if Rails.env == 'development'
          MailRobot.send_bills(email, replyto,
                               m.MailingName, m.Status, m.mooring_num, dues, fees, initiation).deliver
        else
          MailRobot.delay(run_at: i.minutes.from_now).send_bills(email, replyto,
                                                                    m.MailingName, m.Status, m.mooring_num, dues, fees, mooring_maint_fee, initiation)
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
    @mailing = Mailing.find(params[:id])
    people = Person.email_list(@mailing.committee)
    people.each {|e| logger.info "General email: #{e.EmailAddress}" }
    if params[:test]
      p = Person.find_by_EmailAddress(current_user.email)
      people = [p]   #,p2]*120
      people.each do |p|
         logger.info "Test email address: #{p.EmailAddress}"
      end
    else
      @mailing.sent_at = Time.now
      @mailing.save
    end
    people.map! {|p| p.id} 
    self.deliver_mail(people, params[:id].to_i, host)
    flash[:notice] = "Delivering mail."
    redirect_to mailings_path
  end

  def deliver_mail(people, mailing, host)
    logger.info "Delivering mail from #{host}"
    people.each_with_index do |id, i|
      begin
        person = Person.find(id)
        logger.info "   to : #{person.EmailAddress}"
        person.generate_email_hash if person.email_hash.nil?
	#hr = (i/60)
        if Rails.env == 'development'
          MailRobot.mailing(person, mailing, host).deliver
        else
          MailRobot.delay(run_at: i.minutes.from_now).mailing(person, mailing, host)
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
