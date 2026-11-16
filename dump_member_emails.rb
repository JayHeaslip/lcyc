File.open("member_emails", "w") do |o|
  Person.members.each do |p|
    next unless p.EmailAddress.present?

    o.puts p.EmailAddress.strip
  end
end
