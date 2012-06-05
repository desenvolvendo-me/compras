class RenameBudgetStructuresBudgetUnitToBudgetStructure < ActiveRecord::Migration
  def change
    rename_column :budget_structures, :budget_unit, :budget_structure
  end
end
