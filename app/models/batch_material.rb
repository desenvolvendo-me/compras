class BatchMaterial < Compras::Model
  belongs_to :demand_batch
  attr_accessible :name, :demand_batch_id

  scope :demand_batch_id, lambda { |id| where { demand_batch_id.eq(id) } }
  # validates :name, presence: true
  validates :name,:demand_batch, presence: true

  orderize "created_at"
  filterize
end
