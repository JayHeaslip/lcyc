module WaitListEntriesHelper

  def waitlist_date(membership)
    if membership.Status == 'Active' || membership.Status == 'Active2016'
      membership.active_date
    else
      membership.application_date
    end
  end

  def mooring_assigned?(membership)
    membership.mooring_num != nil
  end

  def wl_member(membership)
    membership.people.where(MemberType: 'Member').first
  end

end
