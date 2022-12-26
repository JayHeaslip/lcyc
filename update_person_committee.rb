Person.find_each do |p|
  if p.Committee1
    p.committee = Committee.find_by_Name(p.Committee1)
    p.save
  end
end

                           
