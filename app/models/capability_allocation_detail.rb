class CapabilityAllocationDetail < Compras::Model
  orderize :id
  filterize

  def to_s
    description
  end
end
