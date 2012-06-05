class RenameBudgetUnitConfigurationsToBudgetStructureConfigurations < ActiveRecord::Migration
  def change
    rename_table :budget_unit_configurations, :budget_structure_configurations
  end
end
