class BudgetUnitLevel < ActiveRecord::Base
  attr_accessible :level, :description, :digits, :organogram_separator
  attr_accessible :budget_unit_configuration_id

  has_enumeration_for :organogram_separator, :with => OrganogramSeparator, :create_helpers => true

  belongs_to :budget_unit_configuration

  validates :description, :level, :digits, :presence => true

  orderize :level
  filterize

  def to_s
    "#{level} - #{description}"
  end
end
