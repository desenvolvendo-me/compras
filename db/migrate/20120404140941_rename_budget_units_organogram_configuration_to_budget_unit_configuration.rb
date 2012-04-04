class RenameBudgetUnitsOrganogramConfigurationToBudgetUnitConfiguration < ActiveRecord::Migration
  def change
    rename_column :budget_units, :organogram_configuration_id, :budget_unit_configuration_id
  end
end
