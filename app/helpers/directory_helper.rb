module DirectoryHelper
  def address(membership)
    # Create the city/state/zip line with 3 non-breaking spaces
    state_zip = "#{membership.State}#{('&nbsp;' * 4)}#{membership.Zip}"
    
    full_address = [
      membership.StreetAddress,
      "#{membership.City}, #{state_zip}"
    ].join("\n")
    
    simple_format(full_address)
  end
end
