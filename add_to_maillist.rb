m = Membership.where(Status: 'Non-member')
unless m.nil?
  m = Membership.new(Status: 'Non-member')
  m.save(validate: false)
end

# add additional emails below
p = Person.new(FirstName: 'Head',
                 LastName: 'Steward',
                 EmailAddress: 'lcycheadsteward@gmail.com',
                 subscribe_general: true,
                 MemberType: 'MailList',
                 MembershipID: m.id)
p.save(validate: false)
