User.all.includes(:active_sessions).each do |u|
  if u.active_sessions.size > 0
    puts "keeping #{u.email} #{u.firstname} #{u.lastname}"
  else
    #puts "#{u.email} #{u.firstname} #{u.lastname}"
    #u.destroy
  end
end
