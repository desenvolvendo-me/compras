class CreateRecordPrices < ActiveRecord::Migration
  def change
    create_table :compras_record_prices do |t|
      t.integer :number
      t.integer :year
      t.date :date
      t.date :validaty_date
      t.string :situation
      t.references :licitation_process
      t.text :description
      t.references :delivery_location
      t.references :management_unit
      t.references :responsible
      t.references :payment_method
      t.integer :delivery
      t.string :delivery_unit
      t.integer :validity
      t.string :validaty_unit
      t.text :observations

      t.timestamps
    end

    add_index :compras_record_prices, :licitation_process_id
    add_index :compras_record_prices, :delivery_location_id
    add_index :compras_record_prices, :management_unit_id
    add_index :compras_record_prices, :responsible_id
    add_index :compras_record_prices, :payment_method_id

    add_foreign_key :compras_record_prices, :compras_licitation_processes, :column => :licitation_process_id
    add_foreign_key :compras_record_prices, :compras_delivery_locations, :column => :delivery_location_id
    add_foreign_key :compras_record_prices, :compras_management_units, :column => :management_unit_id
    add_foreign_key :compras_record_prices, :compras_employees, :column => :responsible_id
    add_foreign_key :compras_record_prices, :compras_payment_methods, :column => :payment_method_id
  end
end
