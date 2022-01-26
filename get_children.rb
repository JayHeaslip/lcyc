m = Membership.members

o = File.open('kids.csv', 'w')
m.each do |e|
  e.people.each do |c|
    if c.MemberType == "Child"
      o.puts "#{e.MailingName}, #{c.FirstName}, #{c.LastName}, #{c.BirthYear}"
    end
  end
end
