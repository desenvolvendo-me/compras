class BatchMaterial < Compras::Model
  belongs_to :demand_batch
  belongs_to :material
  attr_accessible :demand_batch_id,:material_id

  scope :demand_batch_id, lambda { |id| where { demand_batch_id.eq(id) } }
  scope :material_id, lambda { |id| where { material_id.eq(id) } }

  validates :demand_batch,:material, presence: true

  orderize "created_at"
  filterize

end
