# read resulting file in text editor (notepad), then cut and paste into an excell spreadsheet
# under Data/Text to Columns, split at semicolon
# sort by first column (partner last name)

all = Membership.all_active.includes(:people)

File.open('partner_xref.csv','w') do |o|
  all.each do |m|
    member = m.people.where(MemberType: 'Member').first
    partner = m.people.where(MemberType: 'Partner').first
    if partner && member.LastName != partner.LastName
      o.puts "#{partner.LastName}, #{partner.FirstName};see;#{member.LastName}, #{member.FirstName}"
    end
  end
end
