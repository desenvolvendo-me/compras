class AddBudgetAllocationToPurchaseProcessBudgetAllocation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_budget_allocations,
               :budget_allocation,:string
  end
end