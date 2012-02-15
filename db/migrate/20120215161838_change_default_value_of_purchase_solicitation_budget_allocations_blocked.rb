class ChangeDefaultValueOfPurchaseSolicitationBudgetAllocationsBlocked < ActiveRecord::Migration
  def up
    change_column_default :purchase_solicitation_budget_allocations, :blocked,  false
  end

  def down
    change_column_default :purchase_solicitation_budget_allocations, :blocked,  nil
  end
end
