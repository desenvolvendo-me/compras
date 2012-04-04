class RenameOrganogramConfigurationsToBudgetUnitConfigurations < ActiveRecord::Migration
  def change
    rename_table :organogram_configurations, :budget_unit_configurations
  end
end
