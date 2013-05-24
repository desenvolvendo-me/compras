class CapabilityAllocationDetail < Accounting::Model
  attr_accessible :description

  has_many :capability_destination_details

  orderize :description
  filterize

  def to_s
    description
  end
end

