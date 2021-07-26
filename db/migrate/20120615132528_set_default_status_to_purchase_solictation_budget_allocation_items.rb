class SetDefaultStatusToPurchaseSolictationBudgetAllocationItems < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE compras_purchase_solicitation_budget_allocation_items
      SET status = 'pending'
    SQL
  end
end
