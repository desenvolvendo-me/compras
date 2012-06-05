class RenameBudgetUnitLevelsToBudgetStructureLevels < ActiveRecord::Migration
  def change
    rename_table :budget_unit_levels, :budget_structure_levels
  end
end
