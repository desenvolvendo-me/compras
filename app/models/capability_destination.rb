class CapabilityDestination < Compras::Model
  attr_accessible :capability_destination_group, :capability_destination_use,
                  :description, :destination, :specification

  has_enumeration_for :capability_destination_use
  has_enumeration_for :capability_destination_group
  has_enumeration_for :destination, :with => CapabilityDestinationKind

  validates :capability_destination_use, :capability_destination_group,
            :specification, :description, :destination, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
