class Company < Unico::Company
  delegate :city, :zip_code, :to => :address, :allow_nil => true

  orderize
  filterize
end
