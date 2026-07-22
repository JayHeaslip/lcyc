require 'yaml'

o = File.open("roles.yml","w")

yaml_data = Role.all.each_with_object({}) do |role, hash|
  # Use role.name or role.name.downcase depending on your key preference
  key = role.name 

  role_data = {
    'name' => role.name
  }

  unless role.rights.empty?
    role_data['rights'] = role.rights.map { |right| right.name.tr('.', '_') }
  end

  hash[key] = role_data
end

o.puts yaml_data.to_yaml
o.close
