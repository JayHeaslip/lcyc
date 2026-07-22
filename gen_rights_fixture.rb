o = File.open("rights.yml", "w")
Right.all.each do |e|
  o.puts "#{e.name.gsub(".","_")}:"
  o.puts "  name: #{e.name}"
  o.puts "  controller: #{e.controller}"
  o.puts "  action: #{e.action}"
end
o.close

