class BinnaclesController < ApplicationController

  def index
    @binnacles = Binnacle.order('publication_date DESC')
  end

  def new
    @binnacle = Binnacle.new
    @binnacle.body = "<p>Attached is the latest binnacle.</p>\n<p>Previous binnacles are available online at http://lcyc.info/club/binnacle</p>"
    # see railscasts 73
    2.times { @binnacle.pdfs.build }
    check_delayed_job
  end

  def create
    @binnacle = Binnacle.new(binnacle_params)
    if @binnacle.save 
      flash[:notice] = "Binnacle was successfully saved."
      redirect_to binnacle_path(@binnacle)
    else
      render :new
    end
  end

  def show
    @binnacle = Binnacle.find(params[:id])
    @test = true
    check_delayed_job
  end

  def edit
    @binnacle = Binnacle.find(params[:id])
  end

  def update
    @binnacle = Binnacle.find(params[:id])
    @binnacle.attributes = binnacle_params
    if @binnacle.save
      flash[:notice] = "Successfully updated binacle."
      redirect_to binnacle_path(@binnacle)
    else
      render :edit
    end
  end

  def email
    @binnacle = Binnacle.find(params[:id])
    @test = true
  end

  def send_email
    binnacle = Binnacle.find(params[:id])
    if params[:test]
      emails = %W(#{current_user.email})
    else
      emails = Person.binnacle_emails
    end
    logger.info "Binnacle email length: #{emails.length}"
    emails.each {|e| logger.info "Binnacle email: #{e}" }
    filenames = binnacle.pdfs.map { |pdf| pdf.pdf.url(:original, false)}
    binnacle_name = "Binnacle #{binnacle.publication_date.strftime("%Y-%m-%d")}"
    #spawn_block do
    body = binnacle.body
    emails.each_with_index do |email, i|
      hr = i/97
      MailRobot.delay(:run_at => hr.hours.from_now).binnacle(email, filenames, binnacle_name, body)
    end
    #end
    flash[:notice] = "Delivering Binnacles."
    redirect_to binnacles_path
  end

  def destroy
    @binnacle = Binnacle.find(params[:id])
    @binnacle.destroy
    redirect_to binnacles_path
  end

  private

  def binnacle_params
    params.require(:binnacle).permit(:publication_date, :body,
                                    pdfs_attributes: Pdf.attribute_names.map(&:to_sym).push(:_destroy).push(:pdf))
  end
  
end
