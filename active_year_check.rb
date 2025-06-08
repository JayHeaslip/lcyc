Membership.members.find_each do |m|
  if m.active_date && m.MemberSince != m.active_date.year
    puts "Active date/MemberSince mismatch for #{m.MailingName}"
  end
end
