class BudgetStructureLevel < Accounting::Model
  include CustomData
  reload_custom_data

  attr_modal :budget_structure_configuration_id, :level, :description

  has_enumeration_for :separator, :with => BudgetStructureSeparator, :create_helpers => true

  belongs_to :budget_structure_configuration

  orderize :level
  filterize

  def to_s
    "#{level} - #{description}"
  end
end
