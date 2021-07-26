class MaterialsControl < Compras::Model
  attr_accessible :material_id, :warehouse_id, :minimum_quantity, :maximum_quantity,
                  :average_quantity, :replacement_quantity

  belongs_to :material
  belongs_to :warehouse
end
