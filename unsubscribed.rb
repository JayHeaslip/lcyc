File.open("unsubscribed.csv","w") do |o|
  Membership.members.includes(:people).find_each do |m|
    m.people.each do |p|
      if p.MemberType == "Member" || p.MemberType == "Partner"
        if !p.subscribe_general and p.EmailAddress and p.EmailAddress != ""
          o.puts "#{m.MailingName}, #{p.FirstName}, #{p.LastName}, #{p.EmailAddress}, #{m.Status}, #{p.MemberType}"
        end
      end
    end
  end
end
