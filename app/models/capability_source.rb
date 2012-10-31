class CapabilitySource < Compras::Model
  orderize
  filterize

  def to_s
    name
  end
end
