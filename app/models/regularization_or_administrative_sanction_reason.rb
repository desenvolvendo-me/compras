class RegularizationOrAdministrativeSanctionReason < ActiveRecord::Base
  attr_accessible :description, :reason_type

  has_enumeration_for :reason_type, :with => RegularizationOrAdministrativeSanctionReasonType, :create_helpers => true

  validates :description, :reason_type, :presence => true

  orderize :id
  filterize

  scope :less_than_or_equal_me, lambda { |id| where { |reason| reason.id.lteq(id) } }

  def to_s
    "Motivo #{count_less_than_or_equal_me}"
  end

  protected

  def count_less_than_or_equal_me
    RegularizationOrAdministrativeSanctionReason.less_than_or_equal_me(id).count
  end
end
