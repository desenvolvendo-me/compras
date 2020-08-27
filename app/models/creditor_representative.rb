class CreditorRepresentative < Unico::CreditorRepresentative
  attr_accessible :representative_person_id

  filterize
  orderize
end
