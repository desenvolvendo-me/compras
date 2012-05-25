class Period < ActiveRecord::Base
  attr_accessible :unit, :amount

  has_enumeration_for :unit, :with => PeriodUnit

  has_many :price_collections, :dependent => :restrict

  validates :unit, :amount, :presence => true

  orderize :unit
  filterize

  def to_s
    "#{amount} #{pluralized_unit}"
  end

  protected

  def pluralized_unit
    if amount > 1
      I18n.t("enumerations.period_unit_plural.#{unit}")
    else
      unit_humanize
    end
  end
end
