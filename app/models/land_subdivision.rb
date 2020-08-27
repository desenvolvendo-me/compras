class LandSubdivision < InscriptioCursualis::LandSubdivision
  has_many :addresses, :dependent => :restrict

  filterize
  orderize
end
