class AddFkToAdministrativeProcessBudgetAllocations < ActiveRecord::Migration
  def change
    add_foreign_key :compras_administrative_process_budget_allocations, :compras_budget_allocations,
      :column => :budget_allocation_id, :name => :adm_proc_bdgt_alloc_budget_allocation_fk

    add_index :compras_administrative_process_budget_allocations, :budget_allocation_id,
      :name => :index_adm_proc_bdgt_alloc_on_budget_allocation_id
  end
end
