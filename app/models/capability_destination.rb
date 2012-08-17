class CapabilityDestination < Compras::Model
  attr_accessible :group, :use, :description, :destination, :specification

  has_enumeration_for :use, :with => CapabilityDestinationUse
  has_enumeration_for :group, :with => CapabilityDestinationGroup
  has_enumeration_for :destination, :with => CapabilityDestinationKind

  validates :use, :group, :specification, :description, :destination,
            :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
