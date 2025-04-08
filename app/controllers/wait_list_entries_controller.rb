class WaitListEntriesController < ApplicationController
  def index
    @wait_list_entries = WaitListEntry.joins(:membership).where("memberships.Status IN ('Active', 'Accepted', 'Associate', 'Inactive', 'Senior')").order("date")
  end

  def new
    setup_variables
  end

  def create
    @membership = Membership.find(params[:wait_list_entry][:membership_id])
    @wait_list_entry = WaitListEntry.new(wait_list_params)
    set_date_from_membership unless params[:force_wld]

    if @wait_list_entry.save
      flash[:notice] = "Wait list entry was successfully created."
      redirect_to wait_list_entries_path
    else
      flash.now[:alert] = @wait_list_entry.errors.full_messages.to_sentence
      setup_variables
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @wait_list_entry = WaitListEntry.find(params[:id])
  end

  def update
    @wait_list_entry = WaitListEntry.find(params[:id])
    @wait_list_entry.attributes = wait_list_params
    wait_list_membership = @wait_list_entry.membership
    unless params[:force_wld]
      @wait_list_entry.date = if wait_list_membership.Status == "Accepted"
        wait_list_membership.application_date
      else
        wait_list_membership.active_date
      end
    end
    if @wait_list_entry.save
      flash[:notice] = "Wait list entry was successfully updated."
      redirect_to wait_list_entries_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wait_list_entry = WaitListEntry.find(params[:id])
    @wait_list_entry.destroy
    redirect_to(wait_list_entries_path)
  end

  def assign
    @wait_list_entry = WaitListEntry.find(params[:id])
    @membership = @wait_list_entry.membership
    if @membership.mooring_eligible
      @moorings = Mooring.unassigned.map { |e| e.id }
    else
      flash[:alert] = "#{@membership.MailingName} is not eligible for a mooring."
      redirect_to wait_list_entries_path
    end
  end

  def mooring_update
    @wait_list_entry = WaitListEntry.find(params[:id])
    @membership = @wait_list_entry.membership
    @membership.mooring = Mooring.find(params[:mooring])
    boat = @membership.boats.first
    if @membership.boats.length == 1
      boat.mooring = @membership.mooring
      boat.location = "Mooring"
    end
    if @membership.save
      boat&.save
      flash[:notice] = "Mooring assigned."
      redirect_to wait_list_entries_path
    else
      @wait_list_entries = WaitListEntry.joins(:membership).where("memberships.Status IN ('Active', 'Accepted', 'Associate', 'Inactive', 'Senior')").order("date")
      flash[:alert] = "Problem assigning mooring."
      render :index, status: :unprocessable_entity
    end
  end

  private

  def wait_list_params
    params.require(:wait_list_entry).permit(:date, :membership_id, :notes)
  end

  def setup_variables
    @memberships = Membership.where(Status: [ "Accepted", "Active", "Associate", "Inactive", "Senior" ], mooring: nil).order("LastName")
    wait_list_memberships = WaitListEntry.all.map { |w| w.membership }
    @memberships -= wait_list_memberships
    @wait_list_entry = WaitListEntry.new
  end

  def set_date_from_membership
    wait_list_membership = @wait_list_entry.membership
    @wait_list_entry.date = if @membership.Status == "Accepted"
                              wait_list_membership.application_date
    else
                              wait_list_membership.active_date
    end
  end
end
