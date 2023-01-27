# RAILS_ENV=production rails c
# load 'set_select_email.rb'

require "csv"
# #csvo = File.open('wd_out.csv','wb')
# #CSV.foreach('./wd.csv') do |row|
##  mn = row[1]
##  status = row[2]
##  wd = row[4]
##  if status == 'Active' && wd != '1'
##    puts wd.class
##    csvo.puts "#{mn}, #{status}"
##  end
# #end
csvo = File.open("nil_out.csv", "wb")

CSV.foreach("./email_list.csv") do |row|
  mailing_name = row[0]
  puts mailing_name
  m = Membership.find_by_MailingName(mailing_name.to_s)
  if m.nil?
    csvo.puts "nil " + mailing_name
  else
    people = m.people.where('MemberType = "Member" OR MemberType = "Partner"')
    people.each { |e|
      e.select_email = true
      e.save
    }
  end
end
csvo.close
