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

                           
