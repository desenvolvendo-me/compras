class AdditiveSolicitationItem < Compras::Model

  attr_accessible :quantity, :value, :material_id, :material

  belongs_to :additive_solicitation
  belongs_to :material
end
