class Period < ActiveRecord::Base
  attr_accessible :unit, :amount

  has_enumeration_for :unit, :with => PeriodUnit

  validates :unit, :amount, :presence => true

  orderize :unit
  filterize

  def to_s
    "#{amount} - #{unit_humanize}"
  end
end
