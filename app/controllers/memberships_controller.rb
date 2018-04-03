require 'prawn'
require 'prawn/measurement_extensions'

class MembershipsController < ApplicationController

  helper_method :sort_column, :sort_direction, :mooring_sort_column
  before_action :get_membership, except: [:index, :moorings, :unassigned_moorings, :new, :create, :destroy, 
                                             :labels, :download_labels,
                                             :spreadsheets, :download_spreadsheet]
  before_action :authorize, only: [:edit, :update, :associate, :save_association, :rmboat]

  def index
    @status_options = %w(Accepted Active Associate Honorary Inactive Life Resigned Senior)
    params[:status] = ['Active', 'Associate', 'Honorary', 'Life', 'Senior'] if params[:status].blank?
    @memberships = filter_memberships(params)
    @memberships = @memberships.order(sort_column + " " + sort_direction)
    @lastname = params[:lastname]
    @selected_status = params[:status] 
    @operator = params[:operator]
    @since = params[:since]
  end

  def new
    @membership = Membership.new
    @membership.application_date = Time.now
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      flash[:notice] = 'Membership was successfully created.'
      redirect_to wl_membership_path(@membership)
    else
      render action: :new
    end      
  end

  def wl
  end

  def wladd
    @wl = WaitListEntry.new
    @wl.membership = @membership
    @wl.save
    redirect_to membership_path(@membership)
  end

  def show
    @membership.people.sort
  end

  def edit
    @membership = Membership.includes(:people, :boats).find(params[:id])
  end

  def update
    @membership = Membership.includes(:people, :boats).find(params[:id])
    @membership.attributes = membership_params
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

  def unassign
    m = Membership.find(params[:id])
    m.mooring_num = nil
    m.save!
    redirect_to moorings_memberships_path
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
    @spreadsheet_options = ["Billing", "Log Members", "Log Fleet", "Member Cards/Workday Checklist"]
  end

  def download_spreadsheet
    export_csv(params[:spreadsheet])
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
    #logger.info "params[:sort] : #{params[:sort]}"
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "LastName"
  end
  
  def mooring_sort_column
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "mooring_num"
  end
  
  def sort_direction
    #logger.info "params[:direction]: #{params[:direction]}"
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
    filename = I18n.l(Time.now, format: :short) + "#{type}"
    if type.start_with?("Member Card")
      content = Person.to_csv
      mime_type = "text/csv"
      filename += ".csv"
    elsif type.start_with?("Log Fleet")
      content = Boat.to_csv
      mime_type = "text/csv"
      filename += ".csv"
    else
      content = Membership.to_csv(type)
      mime_type = "text/csv"
      filename += ".csv"
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
                                       people_attributes: Person.attribute_names.map(&:to_sym).push(:_destroy),
                                       boats_attributes: Boat.attribute_names.map(&:to_sym).push(:_destroy))
  end
  
end
