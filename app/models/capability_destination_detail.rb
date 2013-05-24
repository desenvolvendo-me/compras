class CapabilityDestinationDetail < Accounting::Model
  attr_accessible :status, :capability_destination_id, :capability_allocation_detail_id

  has_enumeration_for :status, :create_helpers => true

  belongs_to :capability_destination
  belongs_to :capability_allocation_detail

  validates :status, :capability_allocation_detail, :presence => true

  orderize :id
  filterize
end
