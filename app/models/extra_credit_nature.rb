class ExtraCreditNature < Compras::Model
  attr_accessible :description, :kind

  has_enumeration_for :kind, :with => ExtraCreditNatureKind

  has_many :extra_credits, :dependent => :restrict

  validates :description, :kind, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
