# execute in console

#generate drysail
if Drysail.find(1).nil?
  (1..12).each do |i|
    Drysail.create!(id: i)
  end
end

#fix mooring
# note: delete boat 805 before running
Boat.find(805).delete

Membership.find_each do |m|
  puts "fixing #{m.MailingName}"
  if m.mooring_num
    mooring = Mooring.find(m.mooring_num)
    m.mooring = mooring
    boats_size = m.boats.size
    m.boats.each do |b|
      if mooring
        b.mooring = mooring
        b.location = "Mooring" if boats_size <= 1
      else
        b.location = nil
      end
    end
    if m.save
      puts "success"
    else
      puts m.errors.full_messages.to_sentence
    end
    mooring.save
  end
end

#fix drysail
Membership.find_each do |m|
  if m.drysail_num
    ds = Drysail.find(m.drysail_num)
    m.drysail = ds
    m.boats.each do |b|
      if b.location == "Parking Lot"
        ds.boat = b
      end
    end
    ds.save
    m.save
  end
end


t = Role.new(name: "Treasurer")
t.save
                           
Person.find_each do |p|
  if p.Committee1
    p.committee = Committee.find_by_Name(p.Committee1)
    p.save
  end
end

Right.synchronize_with_controllers

#remove unassociated boats
Boat.all.each do |b|
  if b.memberships.empty? || b.memberships.first.Status == 'Resigned' ||
     b.memberships.first.Status == 'Deceased' || b.memberships.first.Status == 'Inactive'
    puts "Deleting #{b.Name} #{b.Mfg_Size}"
    b.destroy
  end
end

bog = Role.find_by_name("BOG")
%w(Membership Harbormaster Communications Treasurer).each do |role|
  r = Role.find_by_name(role)
  r.parent = bog
  r.save
end

#execute this command in terminal after running script
#rails chores:load_rights 
