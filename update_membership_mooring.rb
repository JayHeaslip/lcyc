Membership.find_each do |m|
  if m.mooring_num
    m.mooring = Mooring.find(m.mooring_num)
    m.save
  end
end

                           
