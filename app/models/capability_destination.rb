class CapabilityDestination < Compras::Model
  attr_accessible :group, :use, :description, :kind, :specification, :capability_destination_details_attributes

  attr_modal :group, :use, :description, :kind, :specification

  has_enumeration_for :use, :with => CapabilityDestinationUse
  has_enumeration_for :group, :with => CapabilityDestinationGroup
  has_enumeration_for :kind, :with => CapabilityDestinationKind

  has_many :capability_destination_details, :dependent => :destroy
  has_many :capabilities, :dependent => :restrict

  accepts_nested_attributes_for :capability_destination_details, :allow_destroy => true

  validates :use, :group, :specification, :description, :kind,
            :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
