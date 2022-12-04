require 'prawn'
require 'prawn/measurement_extensions'

class MembershipsController < ApplicationController

  helper_method :sort_column, :sort_direction, :mooring_sort_column
  before_action :get_membership, except: [:index, :moorings, :unassigned_moorings, :new_drysail,
                                          :assign_drysail, :drysail, :new, :create, :destroy, 
                                          :labels, :download_labels,
                                          :spreadsheets, :download_spreadsheet, :initiation_report]
  before_action :authorize, only: [:edit, :update, :associate, :save_association, :rmboat]

  def index
    @status_options = %w(Accepted Active Associate Honorary Inactive Life Resigned Senior)
    params[:status] = ['Active', 'Associate', 'Honorary', 'Life', 'Senior'] if params[:status].blank?
    #  https://www.colby.so/posts/filtering-tables-with-rails-and-hotwire
    @memberships = filter_memberships(params)
    @memberships = @memberships.order(sort_column + " " + sort_direction)
    @lastname = params[:lastname]
    @selected_status = params[:status] 
    @operator = params[:operator]
    @since = params[:since]
  end

  def new
    @membership = Membership.new
    @membership.people << Person.new
    @membership.application_date = Time.now
  end

  def add_person
    @membership = Membership.find(params[:id])
    @membership.people << person.new
    render "people"
  end

  def create
    @membership = Membership.new(membership_params)
    logger.info "Creating membership #{@membership}"
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
      redirect_to wl_membership_path(@membership)
    else
      if @membership.errors.any?
        logger.info "#{@membership.errors.count} error prohibited this membership from being saved"
      end
      render :new, status: :unprocessable_entity
    end      
  end

  def wl
  end

  def wladd
    @wl = WaitListEntry.new
    @wl.membership = @membership
    @wl.date = @membership.application_date
    @wl.save
    redirect_to membership_path(@membership)
  end

  def show
    @membership.people.sort
  end

  def edit
    @membership = Membership.includes(:people, :boats, :initiation_installments).find(params[:id])
    logger.info "Current user roles:"
    logger.info Current.user.email
    logger.info @membership.MailingName
    Current.user.roles do |r|
      logger.info r.name
    end
  end

  def update
    @membership = Membership.includes(:people, :boats, :initiation_installments).find(params[:id])
    current_status = @membership.Status
    @membership.attributes = membership_params
    @membership.change_status_date = Time.now.strftime("%Y-%m-%d") if current_status != @membership.Status
    unless @membership.Status.in? ['Active', 'Life', 'Associate']
      flash[:alert] = 'Mooring removed due to membership category' if !@membership.mooring_num.nil?
      @membership.mooring_num = nil
    end
    if @membership.save
      flash[:notice] = 'Membership was successfully updated.'
      redirect_to membership_path(@membership)
    else
      render :edit
    end
  end

  def destroy
    @membership  = Membership.find(params[:id])
    @membership.destroy
    flash[:notice] = 'Membership was successfully deleted.'
    redirect_to memberships_path
  end

  def rmboat
    @boat = Boat.find(params[:boat_id])
    @membership = Membership.find(params[:id])
    @boat.memberships.delete(@membership)
    flash[:notice] = "#{@membership.LastName} removed from boat"
    redirect_to boat_path(@boat)
  end

  def associate
    @membership = Membership.find(params[:id])
    @boats = Boat.order(:Name) - @membership.boats
  end

  def save_association
    @membership = Membership.find(params[:id])
    @membership.boats << Boat.find(params[:membership][:boats].to_i)
    if @membership.save
      flash[:notice] = 'Saved association.'
      redirect_to membership_path(@membership)
    else
      @boats = Boat.order(:Name) - @membership.boats
      render :associate
    end
  end

  def moorings
    session[:breadcrumbs] = request.path
    @memberships = Membership.where('memberships.mooring_num is not NULL').includes(:boats)
    @memberships = @memberships.order(mooring_sort_column + " " + sort_direction)
  end

  def new_drysail
    dry_sail_memberships = Membership.where('memberships.drysail_num is not NULL')
    @memberships = Membership.active - dry_sail_memberships
    @available_dry_sail =  (1..12).to_a - dry_sail_memberships.map {|m| m.drysail_num }
  end

  def assign_drysail
    membership = Membership.find(params[:membership])
    membership.drysail_num = params[:drysail_num]
    if membership.save 
      redirect_to drysail_memberships_path
    else
      redirect_to new_drysail_memberships_path
    end
  end

  def drysail
    session[:breadcrumbs] = request.path
    @memberships = Membership.where('memberships.drysail_num is not NULL').includes(:boats)
    @memberships = @memberships.order(drysail_sort_column + " " + sort_direction)
  end

  def unassign
    m = Membership.find(params[:id])
    m.mooring_num = nil
    m.save!
    redirect_to moorings_memberships_path
  end

  def unassign_drysail
    m = Membership.find(params[:id])
    m.drysail_num = nil
    m.save!
    redirect_to drysail_memberships_path
  end

  def unassigned_moorings
    session[:breadcrumbs] = request.path
    @moorings = Membership.unassigned_moorings
  end

  def labels
    session[:breadcrumbs] = request.path
    @label_options = ["All", "Binnacle", "No Email", "Workday"]
  end

  def download_labels
    workday = false
    case params[:labels]
    when 'All'
      members = Membership.members
    when 'No Email'
      members = Membership.mail_hardcopy
    when 'Binnacle'
      members = Membership.binnacle_hardcopy
    when 'Workday'
      members = Membership.all_active
      workday = true
    end
    send_data generate_labels(members, workday), filename: "labels.pdf", type: "application/pdf"
  end

  def spreadsheets
    session[:breadcrumbs] = request.path
    @spreadsheet_options = ["Billing", "Log Members", "Log Fleet",
                            "Log Partner Xref", "Member Cards/Workday Checklist", "Resigned"]
  end

  def download_spreadsheet
    export_csv(params[:spreadsheet])
  end

  def initiation_report
    installments = InitiationInstallment.includes(:membership).order(:year)
    @initiation_fee_due = []
    installments.each do |i|
      @initiation_fee_due << [i.membership, i.amount, i.year]
    end
  end
  
  private

  def get_membership
    if current_user.roles?(%w(Admin BOG Membership))
      @membership = Membership.find(params[:id])
    else
      @membership = Membership.find(current_user.membership)
    end
  end
  
  # required because BOG is allowed to look at other membership data, but not alter it
  # for the Member role get_membership covers this
  def authorize
    if not current_user.roles?(%w(Admin Membership Harbormaster)) #BOG
      if current_user.membership && current_user.membership != params[:id].to_i
        logger.info "current #{current_user.membership.class}, id #{params[:id].class}"
        flash[:error] = "You are not authorized to view the page you requested."
        request.env["HTTP_REFERER" ] ? (redirect_to :back) : (redirect_to root_path)
        return false
      else
        return true
      end
    else
      return true
    end
  end

  def sort_column
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "LastName"
  end
  
  def mooring_sort_column
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "mooring_num"
  end
  
  def drysail_sort_column
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "drysail_num"
  end
  
  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end

  def generate_labels(list, workday)
    pages = list.length/30 
    Prawn::Document.new(left_margin: 0.21975.in, right_margin: 0.21975.in)  do |p|
      p.font "Times-Roman"
      p.font_size 11
      (0..pages).each  do |page|
        p.define_grid(columns: 3, rows: 10, column_gutter: 10)
        p.grid.rows.times do |i|
          p.grid.columns.times do |j|
            b = p.grid(i,j)
            indent = 10
            p.bounding_box [b.top_left[0]+indent, b.top_left[1]], width: b.width, height: b.height-indent do
              m = list[page*30 + 3*i + j]
              overflow = generate_text(p, m, b.width, workday) if not m.nil?
              logger.info "#{m.MailingName} overflowed: |#{overflow}|" if overflow && overflow != ""
            end
            #p.stroke do
            #  p.rectangle(b.top_left, b.width, b.height)
            #end
          end
        end
        p.start_new_page if page != pages
      end
    end.render
  end

  def generate_text(p,m, width, workday)
    if p.width_of(m.MailingName) > width # need to split mailing name
      sp = m.MailingName.split('&')
      mn = sp[0] + "&\n" + p.indent(5) {sp[1]}
    else 
      mn = m.MailingName
    end
    if p.width_of(m.StreetAddress) > width # need to split address
      sp = m.StreetAddress.split(',')
      ma = sp[0] + "\n" + "  #{sp[1]}"
    else 
      ma = m.StreetAddress
    end
    if workday 
      p.text m.LastName, style: :bold
      p.text "\n\n#{mn}"
    else
      p.text_box "#{mn}\n#{ma}\n#{m.City}, #{m.State}   #{m.Zip}", valign: :center
    end
  end

  def export_csv(type)
    mime_type = "text/csv"
    filename = I18n.l(Time.now, format: :short) + "#{type}"
    filename += ".csv"

    if type.start_with?("Member Card") 
      content = Person.to_csv
    elsif type.start_with?("Resigned") 
      content = Person.resigned_to_csv
    elsif type.start_with?("Log Fleet")
      content = Boat.to_csv
    else
      content = Membership.to_csv(type)
    end
    send_data(content, type: mime_type, filename: filename)
  end 

  def filter_memberships(params)
    @memberships = Membership.all 
    @memberships = @memberships.since(params[:since], params[:operator]) if params[:since].present?
    @memberships = @memberships.lastname(params[:lastname]) if params[:lastname].present?
    @memberships = @memberships.status(params[:status]) if params[:status].present?
  end

  def membership_params
    params.require(:membership).permit(:LastName, :MailingName, :StreetAddress, :City,
                                       :State, :Zip, :Country, :Status, :MemberSince, :mooring_num,
                                       :application_date, :active_date, :resignation_date, :initiation,
                                       :paid, :skip_mooring, :installments, :initiation_fee, :drysail_num, :notes,
                                       people_attributes: Person.attribute_names.map(&:to_sym).push(:_destroy),
                                       boats_attributes: Boat.attribute_names.map(&:to_sym).push(:_destroy),
                                       initiation_installments_attributes: InitiationInstallment.attribute_names.map(&:to_sym).push(:_destroy))
                                       
  end
  
end
