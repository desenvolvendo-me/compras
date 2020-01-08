class AdditiveSolicitationItem < Compras::Model
  attr_accessible :quantity, :material_id

  belongs_to :additive_solicitation
  belongs_to :material
end
