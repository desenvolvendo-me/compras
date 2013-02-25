class RegularizationOrAdministrativeSanctionReason < Compras::Model
  attr_accessible :description, :reason_type

  has_enumeration_for :reason_type, :with => RegularizationOrAdministrativeSanctionReasonType, :create_helpers => true

  validates :description, :reason_type, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
