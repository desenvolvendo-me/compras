class AddSplitExpenseToPurchaseProcessBudgetAllocation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_budget_allocations,
               :split_expense_id,:integer
    add_index :compras_purchase_process_budget_allocations,
              :split_expense_id,name: :cppba_split_expense_idx
    add_foreign_key :compras_purchase_process_budget_allocations,:compras_split_expenses,
                    column: :split_expense_id, name: :cppba_split_expense_fk
  end
end