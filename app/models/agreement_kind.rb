class AgreementKind < Compras::Model
  attr_accessible :description, :tce_code

  validates :description, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
