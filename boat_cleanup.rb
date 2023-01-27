Boat.all.each do |b|
  if b.memberships.empty? || b.memberships.first.Status == "Resigned" ||
      b.memberships.first.Status == "Deceased" || b.memberships.first.Status == "Inactive"
    puts "Deleting #{b.Name} #{b.Mfg_Size}"
    b.destroy
  end
end
