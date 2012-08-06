class AddTotalAllocationsItemsValueToDirectPurchases < ActiveRecord::Migration
  def change
    add_column :compras_direct_purchases, :total_allocations_items_value, :decimal, :precision => 10, :scale => 2
  end
end
