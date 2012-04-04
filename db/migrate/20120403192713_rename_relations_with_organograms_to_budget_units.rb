class RenameRelationsWithOrganogramsToBudgetUnits < ActiveRecord::Migration
  def change
    rename_column :budget_allocations, :organogram_id, :budget_unit_id
    rename_column :organogram_responsibles, :organogram_id, :budget_unit_id
    rename_column :purchase_solicitations, :organogram_id, :budget_unit_id
    rename_column :direct_purchases, :organogram_id, :budget_unit_id
    rename_column :administrative_processes, :organogram_id, :budget_unit_id
  end
end
