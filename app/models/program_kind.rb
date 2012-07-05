class ProgramKind < Compras::Model
  attr_accessible :specification

  orderize :specification
  filterize

  def to_s
    specification
  end
end
