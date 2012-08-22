class CapabilityAllocationDetail < Compras::Model
  attr_accessible :description

  has_many :capability_destination_details

  orderize :description
  filterize

  validates :description, :presence => true, :uniqueness => true

  def to_s
    description
  end
end
