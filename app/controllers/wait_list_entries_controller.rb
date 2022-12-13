class WaitListEntriesController < ApplicationController

  def index
    @wait_list_entries = WaitListEntry.joins(:membership).where("memberships.Status IN ('Active', 'Accepted', 'Associate', 'Inactive', 'Senior')").order("date")
    #wait_list_accepted = WaitListEntry.includes(:membership).where("memberships.Status = 'Accepted'").order("memberships.application_date")
    #@wait_list_entries = @wait_list_entries.to_a.concat(wait_list_accepted)
  end

  def new
    @memberships = Membership.where(Status: ['Accepted', 'Active', 'Associate', 'Inactive', 'Senior'], mooring_num: nil).order("LastName")
    wait_list_memberships = WaitListEntry.all.map { |w| w.membership }
    @memberships -= wait_list_memberships
    @wait_list_entry = WaitListEntry.new
  end

  def create
    @membership = Membership.find(params[:wait_list_entry][:membership_id])
    @wait_list_entry = WaitListEntry.new(wait_list_params)
    unless params[:force_wld]
      if @membership.Status == 'Accepted' then
        @wait_list_entry.date = @wait_list_entry.membership.application_date
      else
        @wait_list_entry.date = @wait_list_entry.membership.active_date
      end
    end
    if @wait_list_entry.save
      flash[:notice] = 'Wait list entry was successfully created.'
      redirect_to wait_list_entries_path
    else
      @memberships = Membership.where(Status: ['Accepted', 'Active', 'Associate', 'Inactive', 'Senior'], mooring_num: nil).order("LastName")
      wait_list_memberships = WaitListEntry.all.map { |w| w.membership }
      @memberships -= wait_list_memberships
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @wait_list_entry = WaitListEntry.find(params[:id])
    render :edit, status: :unprocessable_entity
  end

  def update
    @wait_list_entry = WaitListEntry.find(params[:id])
    @wait_list_entry.attributes = wait_list_params
    if @wait_list_entry.save
      flash[:notice] = 'Wait list entry was successfully updated.'
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
    @moorings = Membership.unassigned_moorings
  end

  def mooring_update
    @wait_list_entry = WaitListEntry.find(params[:id])
    @membership = @wait_list_entry.membership
    @membership.mooring_num = params[:mooring].to_i
    boat = @membership.boats.first
    if @membership.boats.length == 1
      boat.mooring_num = @membership.mooring_num 
      boat.location = "Mooring"
    end
    if @membership.save
      boat.save if boat
      flash[:notice] = 'Mooring assigned.'
      redirect_to wait_list_entries_path
    else
      @wait_list_entries = WaitListEntry.joins(:membership).where("memberships.Status IN ('Active', 'Accepted', 'Associate', 'Inactive', 'Senior')").order("date")
      #wait_list_accepted = WaitListEntry.includes(:membership).where("memberships.Status = 'Accepted'").order("memberships.application_date")
      #@wait_list_entries = @wait_list_entries.to_a.concat(wait_list_accepted)
      flash[:error] = 'Problem assigning mooring.'
      render :index, status: :unprocessable_entity
    end
  end

  private

  def wait_list_params
    params.require(:wait_list_entry).permit(:date, :membership_id)
  end

end
