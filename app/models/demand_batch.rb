class DemandBatch < Compras::Model
  belongs_to :demand
  attr_accessible :name,:demand_id

  has_many :batch_materials, class_name: 'BatchMaterial', :order => :id,dependent: :destroy

  scope :demand_id, lambda { |id| where { demand_id.eq(id) } }

  validates :name,:demand, presence: true

  orderize "created_at"
  filterize

  def to_s
    "#{name}"
  end

end
