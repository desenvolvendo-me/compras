class RemoveBudgetStructureFromAdministrativeProcess < ActiveRecord::Migration
  def change
    remove_column :administrative_processes, :budget_structure_id
  end
end
