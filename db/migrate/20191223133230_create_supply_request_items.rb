class CreateSupplyRequestItems < ActiveRecord::Migration
  def change
    create_table :compras_supply_request_items do |t|
      t.integer :authorization_quantity
      t.integer :supply_request_id
      t.decimal :authorization_value, precision: 10, scale: 2
      t.integer :pledge_item_id
      t.integer :material_id
      t.integer :quantity

      t.timestamps
    end
  end
end
