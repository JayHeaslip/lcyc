# RAILS_ENV=production rails c
# load 'set_select_email.rb'

csvo = File.open('wd_out.csv','wb')
CSV.foreach('./wd.csv') do |row|
  mn = row[1]
  status = row[2]
  wd = row[4]
  if status == 'Active' && wd != '1'
    puts wd.class
    csvo.puts "#{mn}, #{status}"
  end
end
csvo.close
#m = Membership.find_by_MailingName("#{mailing_name}")
#people = m.people.where('MemberType = "Member" OR MemberType = "Partner"')
#people.each { |e|  e.select_email = true; e.save }
