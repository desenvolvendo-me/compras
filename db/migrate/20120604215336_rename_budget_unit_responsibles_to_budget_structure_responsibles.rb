class RenameBudgetUnitResponsiblesToBudgetStructureResponsibles < ActiveRecord::Migration
  def change
    rename_table :budget_unit_responsibles, :budget_structure_responsibles
  end
end
