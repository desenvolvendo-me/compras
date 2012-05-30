class LandSubdivision < Unico::LandSubdivision
  has_many :addresses, :dependent => :restrict

  filterize
  orderize
end
