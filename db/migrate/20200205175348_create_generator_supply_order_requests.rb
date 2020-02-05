class CreateGeneratorSupplyOrderRequests < ActiveRecord::Migration
  def change
    create_table :compras_generator_supply_order_requests do |t|
      t.references :generator_supply_order
      t.references :supply_request

      t.timestamps
    end
  end
end
