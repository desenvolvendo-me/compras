class RegularizationOrAdministrativeSanctionReason < ActiveRecord::Base
  attr_accessible :description, :reason_type

  has_enumeration_for :reason_type, :with => RegularizationOrAdministrativeSanctionReasonType, :create_helpers => true

  validates :description, :reason_type, :presence => true

  orderize :id
  filterize

  def to_s
    description
  end
end
