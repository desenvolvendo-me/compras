class AdditionalCreditOpening < ActiveRecord::Base
  attr_accessible :entity_id, :year, :credit_type

  has_enumeration_for :credit_type, :with => AdditionalCreditOpeningCreditType

  belongs_to :entity

  validates :year, :mask => '9999'
  validates :year, :entity, :credit_type, :presence => true

  orderize :year
  filterize

  def to_s
    "#{year}"
  end
end
