# RAILS_ENV=production rails c
# load 'reset_select_email.rb'

p = People.where('select_email is true')
p.each {|e| e.select_email = false; e.save }
