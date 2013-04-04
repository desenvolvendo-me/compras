class AddExpenseNatureIdAndEstimatedValueToPurchaseSolicitationBudgetAllocations < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_budget_allocations, :expense_nature_id, :integer
    add_column :compras_purchase_solicitation_budget_allocations, :estimated_value, :decimal, :precision => 10, :scale => 2, :default => 0.0

    add_index :compras_purchase_solicitation_budget_allocations, :expense_nature_id, :name => :cpsba_expense_nature_idx
    add_foreign_key :compras_purchase_solicitation_budget_allocations, :compras_expense_natures,
                    :column => :expense_nature_id, :name => :cpsba_expense_nature_fk
  end
end
