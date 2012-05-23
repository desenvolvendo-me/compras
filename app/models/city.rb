class City < Unico::City
  has_many :agencies, :dependent => :restrict

  orderize
  filterize
end
