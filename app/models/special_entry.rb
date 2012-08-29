class SpecialEntry < Compras::Model
  attr_accessible :name

  validates :name, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
