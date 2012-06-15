class AddStatusToPurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_budget_allocation_items, :status, :string
  end
end
