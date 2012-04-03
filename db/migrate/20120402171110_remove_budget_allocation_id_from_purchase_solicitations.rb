class RemoveBudgetAllocationIdFromPurchaseSolicitations < ActiveRecord::Migration
  def change
    remove_column :purchase_solicitations, :budget_allocation_id
  end
end
