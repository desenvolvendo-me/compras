class AddFulfillerToComprasPurchaseSolicitationBudgetAllocationItems < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_budget_allocation_items, :fulfiller_id, :integer
    add_column :compras_purchase_solicitation_budget_allocation_items, :fulfiller_type, :string

    add_index :compras_purchase_solicitation_budget_allocation_items, [:fulfiller_id, :fulfiller_type], :name => :psbai_fulfiller_id_fulfiller_type_idx
  end
end
