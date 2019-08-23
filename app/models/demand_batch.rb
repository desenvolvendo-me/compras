class DemandBatch < Compras::Model
  belongs_to :demand
  attr_accessible :description
end
