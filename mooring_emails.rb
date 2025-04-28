File.open("mooring_email.csv", "w") do |o|
  o.puts "Mooring#, First Name, Last Name, Email, MemberSince"
  Mooring.find_each do |m|
    m.memberships.each do |mem|
      member = mem.people.where(MemberType: "Member").first
      o.puts "#{m.id}, #{member.FirstName}, #{member.LastName}, #{member.EmailAddress}, #{mem.MemberSince}"
    end
  end
end
