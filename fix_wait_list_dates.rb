WaitListEntry.all.each do |e|
  unless e.date
    e.date = e.membership.active_date
    e.save
  end
end
