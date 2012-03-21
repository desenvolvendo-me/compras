class AdditionalCreditOpeningNature < ActiveRecord::Base
  attr_accessible :description, :kind

  has_enumeration_for :kind, :with => AdditionalCreditOpeningNatureKind

  validates :description, :kind, :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end
