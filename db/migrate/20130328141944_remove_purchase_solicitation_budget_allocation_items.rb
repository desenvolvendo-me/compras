class RemovePurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    drop_table :compras_purchase_solicitation_budget_allocation_items
  end
end
