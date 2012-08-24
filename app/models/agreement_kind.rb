class AgreementKind < Compras::Model
  attr_accessible :description, :tce_code

  has_many :agreements, :dependent => :restrict

  validates :description, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
