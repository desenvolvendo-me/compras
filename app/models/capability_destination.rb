class CapabilityDestination < Compras::Model
  attr_modal :group, :use, :description, :kind, :specification

  orderize :description
  filterize

  def to_s
    description
  end
end
