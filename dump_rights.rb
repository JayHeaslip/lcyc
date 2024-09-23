Role.all.each do |role|
  f = File.open("#{role.name}.rights", "w")
  role.rights.each do |right|
    f.puts "#{right.name}"
  end
  f.close
end
