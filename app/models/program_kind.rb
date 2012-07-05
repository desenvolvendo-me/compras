class ProgramKind < Compras::Model
  attr_accessible :specification

  validates :specification, :presence => true

  orderize :specification
  filterize

  def to_s
    specification
  end
end
