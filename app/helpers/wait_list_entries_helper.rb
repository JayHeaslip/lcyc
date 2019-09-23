module WaitListEntriesHelper

  def waitlist_date(membership)
    if membership.Status == 'Active' || membership.Status == 'Associate'
      membership.active_date
    else
      membership.wait_list_date
    end
  end

  def mooring_assigned?(membership)
    membership.mooring_num != nil
  end

  def wl_member(membership)
    membership.people.where(MemberType: 'Member').first
  end

end
