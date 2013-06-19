class AddAuthorizationValueToSupplyOrderItems < ActiveRecord::Migration
  def change
    add_column :compras_supply_order_items, :authorization_value, :decimal,
      precision: 10, scale: 2
  end
end
