class DropTableBudgetAllocationsPurchaseSolicitations < ActiveRecord::Migration
  def change
    remove_foreign_key :purchase_solicitations, :budget_allocations

    drop_table :budget_allocations_purchase_solicitations
  end
end
