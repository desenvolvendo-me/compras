class RenameBudgetAllocationsBudgetUnitIdToBudgetStructureId < ActiveRecord::Migration
  def change
    rename_column :budget_allocations, :budget_unit_id, :budget_structure_id
  end
end
