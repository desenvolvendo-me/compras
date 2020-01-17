class CreateSupplyOrderRequests < ActiveRecord::Migration
  def change
    create_table :compras_supply_order_requests do |t|
      t.references :supply_order
      t.references :supply_request

      t.timestamps
    end
  end
end
