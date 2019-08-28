class DemandBatch < Compras::Model
  belongs_to :demand
  attr_accessible :description

  has_many :batch_material, class_name: 'BatchMaterial', :order => :id,dependent: :destroy

  validates :description, presence: true
end
