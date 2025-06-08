require "prawn"
require "prawn/measurement_extensions"

class MembershipsController < ApplicationController
  helper_method :sort_column, :sort_direction, :mooring_sort_column

  def index
    @status_options = %w[Accepted Active Associate Honorary Inactive Life Resigned Senior]
    params[:status] ||= [ "Active", "Associate", "Honorary", "Life", "Senior" ]
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

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      flash[:success] = "Membership was successfully created."
      redirect_to wl_membership_path(@membership)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def wl
    @membership = Membership.find(params[:id])
  end

  def wladd
    @membership = Membership.find(params[:id])
    @wl = WaitListEntry.new
    @wl.membership = @membership
    @wl.date = @membership.application_date
    @wl.save
    redirect_to membership_path(@membership)
  end

  def show
    set_filter_params
    set_back_path
    @membership = Membership.find(params[:id])
    @membership.people.sort
  end

  def edit
    @membership = Membership.includes(:people, :boats, :initiation_installments).find(params[:id])
  end

  def update
    @membership = Membership.includes(:people, :boats, :initiation_installments).find(params[:id])
    current_status = @membership.Status
    @membership.attributes = membership_params
    @membership.change_status_date = Time.now.strftime("%Y-%m-%d") if current_status != @membership.Status
    @membership.resignation_date = Time.now.strftime("%Y-%m-%d") if @membership.Status == "Resigned" && @membership.resignation_date.nil?
    if (current_status == "Inactive") && (@membership.Status == "Active")
      flash[:alert] = "For members returning to Active status from Inactive status, if adding to the waitlist, the waitlist date should be the day payment is received for the return to Active."
    end
    unless @membership.mooring_eligible
      flash[:alert] = "Mooring removed due to membership category update." if !@membership.mooring.nil?
      @membership.mooring = nil
      @membership.remove_boat_from_mooring
    end
    unless @membership.wait_list_eligible
      flash[:alert] = "Member removed from wait list due to membership category update." if !@membership.wait_list_entry.nil?
      @membership.wait_list_entry = nil
    end
    if @membership.save
      flash.delete(:alert) if flash[:alert].blank?
      flash[:success] = "Membership was successfully updated."
      @membership.check_mooring
      @membership.check_drysail
      redirect_to membership_path(@membership)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    flash[:success] = "Membership was successfully deleted."
    redirect_to memberships_path(since: session[:since],
                                 operator: session[:operator],
                                 lastname: session[:lastname],
                                 status: session[:status],
                                 sort: session[:sort],
                                 direction: session[:direction])
  end

  def associate
    @membership = Membership.find(params[:id])
    @boats = Boat.order(:Name) - @membership.boats
  end

  def save_association
    @membership = Membership.find(params[:id])
    @boat = Boat.find(params[:membership][:boats])
    @membership.boats << @boat
    @membership.mooring = @boat.mooring if @boat.location == "Mooring"
    if @membership.save
      flash[:notice] = "Saved association."
      redirect_to membership_path(@membership)
    else
      # :nocov:
      @boats = Boat.order(:Name) - @membership.boats
      flash[:alert] = "Error saving association."
      render :associate, status: :unprocessable_entity
      # :nocov:
    end
  end

  def unassign
    @membership = Membership.find(params[:id])
    mooring_id = @membership.mooring_id
    @membership.mooring = nil
    @membership.remove_boat_from_mooring
    if @membership.save
      flash[:notice] = "Mooring ##{mooring_id} unassigned."
    else
      # :nocov:
      flash[:alert] = "Problem unassigning mooring ##{mooring_id}."
      # :nocov:
    end
    redirect_to moorings_path
  end

  def unassign_drysail
    @membership = Membership.find(params[:id])
    drysail = @membership.drysail
    @membership.remove_boat_from_drysail
    @membership.drysail = nil
    if @membership.save
      flash[:notice] = "Dry sail spot ##{drysail.id} unassigned."
    else
      # :nocov:
      flash[:alert] = "Problem unassigning dry sail spot ##{drysail.id}."
      # :nocov:
    end
    redirect_to drysails_path
  end

  def labels
    @label_options = [ "All", "No Email", "Workday" ]
  end

  def download_labels
    workday = false
    case params[:labels]
    when "All"
      members = Membership.members
    when "No Email"
      members = Membership.mail_hardcopy
    when "Workday"
      members = Membership.all_active
      workday = true
    end
    send_data generate_labels(members, workday), filename: "labels.pdf", type: "application/pdf"
  end

  def spreadsheets
    @spreadsheet_options = [ "Billing", "Log Members", "Log Fleet",
      "Log Partner Xref", "Member Cards/Workday Checklist", "Evite", "Resigned" ]
  end

  def download_spreadsheet
    Membership.reset_flash_message
    export_csv(params[:spreadsheet])
  end

  def initiation_report
    installments = InitiationInstallment.includes(:membership).order(:year)
    @initiation_fee_due = []
    installments.each do |i|
      next if i.membership.Status != "Active" && i.membership.Status != "Associate"
      @initiation_fee_due << [ i.membership, i.membership.Status, i.membership.MemberSince, i.membership.active_date, i.amount, i.year ]
    end
  end

  private

  def sort_column
    Membership.column_names.include?(params[:sort]) ? params[:sort] : "LastName"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def generate_labels(list, workday)
    pages = list.length / 30
    Prawn::Document.new(left_margin: 0.21975.in, right_margin: 0.21975.in) do |p|
      p.font "Times-Roman"
      p.font_size 11
      (0..pages).each do |page|
        p.define_grid(columns: 3, rows: 10, row_gutter: 0, column_gutter: 10)
        p.grid.rows.times do |i|
          p.grid.columns.times do |j|
            b = p.grid(i, j)
            indent = 10
            p.bounding_box [ b.top_left[0] + indent, b.top_left[1] ], width: b.width, height: b.height - indent do
              m = list[page * 30 + 3 * i + j]
              overflow = generate_text(p, m, b.width, workday) if !m.nil?
              logger.error "#{m.MailingName} overflowed: |#{overflow}|" if overflow && overflow != ""
            end
            # p.stroke do
            #  p.rectangle(b.top_left, b.width, b.height)
            # end
          end
        end
        p.start_new_page if page != pages
      end
    end.render
  end

  def generate_text(p, m, width, workday)
    if p.width_of(m.MailingName) > width # need to split mailing name
      if m.MailingName.index(" & ")
        sp = m.MailingName.split(" & ")
        mn = sp[0] + " &\n" + p.indent(5) { sp[1] }
      elsif m.MailingName.index(" and ")
        sp = m.MailingName.split(" and ")
        mn = sp[0] + " &\n" + p.indent(5) { sp[1] }
      else
        # truncate
        mn = m.MailingName.slice(0, width - 1)
      end
    else
      mn = m.MailingName
    end
    if p.width_of(m.StreetAddress) > width # need to split address
      sp = m.StreetAddress.split(",")
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
    filename = I18n.l(Time.now, format: :short) + type.to_s
    filename += ".csv"

    content = if type.start_with?("Member Card")
                Person.to_csv
    elsif type.start_with?("Resigned")
                Person.resigned_to_csv
    elsif type.start_with?("Log Fleet")
                Boat.to_csv
    else # billing
                Membership.to_csv(type)
    end
    if Membership.flash_message != ""
      flash[:error] = "Error:\n #{Membership.flash_message}"
      redirect_to spreadsheets_memberships_path
    else
      send_data(content, type: mime_type, filename: filename)
    end
  end

  def filter_memberships(params)
    @memberships = Membership.all
    save_params
    @memberships = @memberships.since(params[:since], params[:operator]) if params[:since].present?
    @memberships = @memberships.lastname(params[:lastname]) if params[:lastname].present?
    @memberships = @memberships.status(params[:status]) if params[:status].present?
  end

  def membership_params
    params.require(:membership).permit(:LastName, :MailingName, :StreetAddress, :City,
      :State, :Zip, :Country, :Status, :MemberSince, :mooring,
      :application_date, :active_date, :resignation_date, :initiation,
      :paid, :skip_mooring, :prefer_partner_email, :installments, :initiation_fee, :drysail_num, :notes,
      people_attributes: Person.attribute_names.map(&:to_sym).push(:_destroy),
      boats_attributes: Boat.attribute_names.map(&:to_sym).push(:_destroy),
      initiation_installments_attributes: InitiationInstallment.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def save_params
    session[:since] = params[:since]
    session[:operator] = params[:operator]
    session[:lastname] = params[:lastname]
    session[:status] = params[:status]
    session[:sort] = params[:sort]
    session[:direction] = params[:direction]
  end

  def set_filter_params
    @since = session[:since]
    @operator = session[:operator]
    @lastname = session[:lastname]
    @status = session[:status]
    @direction = session[:direction]
    @sort = session[:sort]
  end

  def set_back_path
    session[:membership_referrer] = request.referrer unless request.referrer&.match(/memberships\/\d+\/edit/)
    if session[:membership_referrer]&.match(/memberships\/index/)
      @back_path = memberships_path(since: @since,
                                  operator: @operator,
                                  lastname: @lastname,
                                  status: @status,
                                  sort: @sort,
                                  direction: @direction)
    elsif session[:membership_referrer]
      @back_path = session[:membership_referrer]
    else
      @back_path = root_path
    end
  end
end
