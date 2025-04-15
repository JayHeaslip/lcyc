# execute in console

Membership.find_each do |m|
  mooring_used = false
  m.boats.each do |b|
    if m.mooring && b.mooring != m.mooring && b.location != "Mooring" && !mooring_used
      puts "Boat location may be incorrect"
      puts " Members #{m.MailingName}"
      puts " Boat #{b.Mfg_Size}"
    end
    mooring_used = true if b.location == "Mooring"
  end
end

# fix drysail
Membership.find_each do |m|
  m.boats.each do |b|
    if m.drysail && b.drysail != m.drysail && b.location != "Mooring"
      puts "Boat location may be incorrect(PL)"
      puts " Members #{m.MailingName}"
      puts " Boat #{b.Mfg_Size}"
    end
  end
end

# remove unassociated boats
Boat.all.each do |b|
  if b.memberships.empty? || b.memberships.first.Status == "Resigned" ||
      b.memberships.first.Status == "Deceased" || b.memberships.first.Status == "Inactive"
    puts "Deleting #{b.Name} #{b.Mfg_Size}"
    b.destroy
  end
end

# execute these commands in terminal after running script
# RAILS_ENV=[staging|production] rails chores:load_rights
# RAILS_ENV=[staging|production] rails chores:load_rights
