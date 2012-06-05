class RenameAdministrativeProcessesBudgetUnitIdToBudgetStructureId < ActiveRecord::Migration
  def change
    rename_column :administrative_processes, :budget_unit_id, :budget_structure_id
  end
end
