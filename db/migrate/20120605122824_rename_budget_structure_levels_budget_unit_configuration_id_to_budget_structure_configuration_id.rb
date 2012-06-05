class RenameBudgetStructureLevelsBudgetUnitConfigurationIdToBudgetStructureConfigurationId < ActiveRecord::Migration
  def change
    rename_column :budget_structure_levels, :budget_unit_configuration_id, :budget_structure_configuration_id
  end
end
