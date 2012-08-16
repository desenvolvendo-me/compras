class CapabilitySource < Compras::Model
  attr_accessible :code, :name, :source, :specification

  has_enumeration_for :source

  validates :code, :name, :specification, :source, :presence => true
  validates :code, :uniqueness => true

  orderize
  filterize

  def to_s
    name
  end
end
