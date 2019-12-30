class AddSupplyRequestIdToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :supply_request_id, :integer
  end
end
