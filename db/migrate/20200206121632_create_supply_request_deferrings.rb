class CreateSupplyRequestDeferrings < ActiveRecord::Migration
  def change
    create_table :compras_supply_request_deferrings do |t|
      t.text :justification
      t.date :date
      t.integer :supply_request_id
      t.integer :responsible_id
      t.integer :sequence
      t.string :service_status

      t.timestamps
    end
  end
end
