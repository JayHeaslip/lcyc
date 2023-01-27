Mailing.find_each do |m|
  if m.sent_at.nil? && m.created_at.year < 2018
    puts m.id
    m.sent_at = m.created_at
    m.save(validate: false)
  end
end
