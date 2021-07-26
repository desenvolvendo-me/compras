class AddQuantityToSupplyOrderItem < ActiveRecord::Migration
  def change
    add_column :compras_supply_order_items,
               :quantity, :integer
  end
end
