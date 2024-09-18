Dir.glob("*.rights").each do |file|
  role_name = file.gsub(/.rights/,"")
  role = Role.find_by(name: role_name)
  role.rights = []
  File.foreach(file) do |line|
    role.rights << Right.find_by(name: line.chomp)
  end
  role.save
end

