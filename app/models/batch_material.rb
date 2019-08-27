class BatchMaterial < Compras::Model
  belongs_to :demand_batch
  attr_accessible :description
end
