class CreatePriceCollections < ActiveRecord::Migration
  def change
    create_table :price_collections do |t|
      t.integer :collection_number
      t.integer :year
      t.date :date
      t.references :delivery_location
      t.references :employee
      t.references :payment_method
      t.references :period
      t.text :object_description
      t.text :observations
      t.integer :proposal_validity_id
      t.date :expiration
      t.string :status

      t.timestamps
    end

    add_index :price_collections, :delivery_location_id
    add_index :price_collections, :employee_id
    add_index :price_collections, :payment_method_id
    add_index :price_collections, :period_id
    add_index :price_collections, :proposal_validity_id

    add_foreign_key :price_collections, :delivery_locations
    add_foreign_key :price_collections, :employees
    add_foreign_key :price_collections, :payment_methods
    add_foreign_key :price_collections, :periods

    add_index :price_collections, [:collection_number, :year], :unique => true
  end
end
