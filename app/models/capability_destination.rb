class CapabilityDestination < Compras::Model
  attr_accessible :group, :use, :description, :kind, :specification

  has_enumeration_for :use, :with => CapabilityDestinationUse
  has_enumeration_for :group, :with => CapabilityDestinationGroup
  has_enumeration_for :kind, :with => CapabilityDestinationKind

  validates :use, :group, :specification, :description, :kind,
            :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
