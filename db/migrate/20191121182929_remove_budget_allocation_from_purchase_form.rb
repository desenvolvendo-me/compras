class RemoveBudgetAllocationFromPurchaseForm < ActiveRecord::Migration
  def up
      remove_column :compras_purchase_forms,
                    :budget_allocation
  end

  def down
      add_column :compras_purchase_forms,
                 :budget_allocation, :string
  end
end