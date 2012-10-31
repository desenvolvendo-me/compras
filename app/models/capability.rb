class Capability < Compras::Model
  attr_modal :descriptor_id, :description, :kind, :status

  has_enumeration_for :kind, :with => CapabilityKind
  has_enumeration_for :status, :create_helpers => true

  belongs_to :descriptor

  orderize :id
  filterize

  def to_s
    description
  end
end
