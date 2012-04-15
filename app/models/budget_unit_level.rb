class BudgetUnitLevel < ActiveRecord::Base
  attr_accessible :level, :description, :digits, :separator
  attr_accessible :budget_unit_configuration_id

  has_enumeration_for :separator, :with => BudgetUnitSeparator, :create_helpers => true

  belongs_to :budget_unit_configuration

  validates :description, :level, :digits, :presence => true

  orderize :level
  filterize

  def to_s
    "#{level} - #{description}"
  end
end
