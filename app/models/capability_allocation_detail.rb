class CapabilityAllocationDetail < Compras::Model
  orderize "id DESC"
  filterize

  def to_s
    description
  end
end
