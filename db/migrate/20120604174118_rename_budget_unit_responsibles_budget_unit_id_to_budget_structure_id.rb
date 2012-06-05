class RenameBudgetUnitResponsiblesBudgetUnitIdToBudgetStructureId < ActiveRecord::Migration
  def change
    rename_column :budget_unit_responsibles, :budget_unit_id, :budget_structure_id
  end
end
