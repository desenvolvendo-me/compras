class RemoveFieldsFromPurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_solicitation_budget_allocation_items, :status
    remove_column :compras_purchase_solicitation_budget_allocation_items, :fulfiller_id
    remove_column :compras_purchase_solicitation_budget_allocation_items, :fulfiller_type
  end
end
