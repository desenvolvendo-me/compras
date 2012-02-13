class RemovePurchaseSolicitationBudgetAllocationsExpenseComplement < ActiveRecord::Migration
  def up
    remove_column :purchase_solicitation_budget_allocations, :expense_complement
  end
end
