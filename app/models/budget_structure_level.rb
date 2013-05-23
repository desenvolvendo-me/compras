class BudgetStructureLevel < Accounting::Model
  include CustomData
  reload_custom_data

  attr_modal :budget_structure_configuration_id, :level, :description

  has_enumeration_for :separator, :with => BudgetStructureSeparator, :create_helpers => true

  belongs_to :budget_structure_configuration

  orderize :level
  filterize

  scope :configuration_id, lambda { |configuration_id| where {
     budget_structure_configuration_id.eq(configuration_id) }
  }

  def to_s
    "#{level} - #{description}"
  end

  def mask
    '9' * digits
  end

  def upper_budget_structure_level
    return nil if level == 1
    upper_level_number = level.pred

    BudgetStructureLevel.where {
      budget_structure_configuration_id.eq( my{budget_structure_configuration_id} ) &
      level.eq(upper_level_number) }.first
  end
end
