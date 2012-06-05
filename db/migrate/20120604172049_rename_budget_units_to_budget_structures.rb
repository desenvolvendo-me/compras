class RenameBudgetUnitsToBudgetStructures < ActiveRecord::Migration
  def change
    rename_table :budget_units, :budget_structures
  end
end
