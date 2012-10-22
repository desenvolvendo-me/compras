class AgreementKind < Compras::Model
  attr_accessible :description, :tce_code

  has_many :agreements, :dependent => :restrict

  orderize :description
  filterize
end
