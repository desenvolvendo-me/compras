class RemoveAllocationAmountFromPurchaseSolicitation < ActiveRecord::Migration
  def change
    remove_column :purchase_solicitations, :allocation_amount
  end
end
