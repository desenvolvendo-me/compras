class RenameOrganogramLevelsOrganogramConfigurationToBudgetUnitConfiguration < ActiveRecord::Migration
  def up
    rename_column :organogram_levels, :organogram_configuration_id, :budget_unit_configuration_id
  end
end
