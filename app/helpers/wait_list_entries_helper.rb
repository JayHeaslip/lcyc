module WaitListEntriesHelper
  def wl_boat_type(membership)
    membership.boats.first&.Mfg_Size
  end
end
