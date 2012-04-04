class RenameOrganogramLevelsToBudgetUnitLevels < ActiveRecord::Migration
  def up
    rename_table :organogram_levels, :budget_unit_levels
  end
end
