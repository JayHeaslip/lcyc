
class MailingsController < ApplicationController

  skip_before_action :authenticate_user!, :check_authorization, only: [:deliver_mail]
  
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
      flash[:notice] = "Success."
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
     # begin
        person = Person.find(id)
        person.generate_email_hash if person.email_hash.nil?
	#hr = (i/60)
        if Rails.env == 'development' || Rails.env == 'test'
          MailRobot.mailing(person, mailing, host, filtered).deliver
        else
          MailRobot.mailing(person, mailing, host, filtered).deliver_later(wait_until: (i*30).seconds.from_now)
        end
      #rescue
      #  logger.info "Person not found: #{id}"
      #end
    end
  end
  
  private

  def host
    request.url.gsub(/mailings.*/,'')
  end

  def mailing_params
    params.require(:mailing).permit(:committee, :subject, :replyto, :content)

  end

end
