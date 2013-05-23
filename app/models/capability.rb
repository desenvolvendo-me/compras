class Capability < Accounting::Model
  attr_modal :description, :kind, :status

  belongs_to :descriptor

  has_enumeration_for :kind, :with => CapabilityKind
  has_enumeration_for :status, :create_helpers => true

  orderize "id DESC"
  filterize

  def to_s
    description
  end
end
