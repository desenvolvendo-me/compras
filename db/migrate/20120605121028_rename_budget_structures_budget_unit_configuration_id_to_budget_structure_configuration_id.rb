class RenameBudgetStructuresBudgetUnitConfigurationIdToBudgetStructureConfigurationId < ActiveRecord::Migration
  def change
    rename_column :budget_structures, :budget_unit_configuration_id, :budget_structure_configuration_id
  end
end
