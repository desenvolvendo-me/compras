class LandSubdivision < InscriptioCursualis::LandSubdivision
  attr_accessible :name

  has_many :addresses, :dependent => :restrict

  filterize
  orderize
end
