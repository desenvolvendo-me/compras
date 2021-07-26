class AddOrderStatusToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :order_status, :string
  end
end
