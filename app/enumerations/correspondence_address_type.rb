class CorrespondenceAddressType < EnumerateIt::Base
  associate_values :person_address, :person_correspondence_address, :own_address
end
