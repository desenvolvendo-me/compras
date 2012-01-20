class CreateDeliveryLocations < ActiveRecord::Migration
  def change
    create_table :delivery_locations do |t|
      t.string :name
      t.references :address

      t.timestamps
    end
    add_index :delivery_locations, :address_id
    add_foreign_key :delivery_locations, :addresses
  end
end
