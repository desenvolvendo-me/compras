class CreateDirectPurchases < ActiveRecord::Migration
  def change
    create_table :direct_purchases do |t|
      t.integer :year
      t.date :date
      t.references :legal_reference
      t.string :modality
      t.references :provider
      t.references :organogram
      t.references :licitation_object
      t.references :delivery_location
      t.references :employee
      t.references :payment_method
      t.string :price_collection
      t.string :price_registration
      t.text :observation

      t.timestamps
    end

    add_index :direct_purchases, :legal_reference_id
    add_index :direct_purchases, :provider_id
    add_index :direct_purchases, :organogram_id
    add_index :direct_purchases, :licitation_object_id
    add_index :direct_purchases, :delivery_location_id
    add_index :direct_purchases, :employee_id
    add_index :direct_purchases, :payment_method_id

    add_foreign_key :direct_purchases, :legal_references
    add_foreign_key :direct_purchases, :providers
    add_foreign_key :direct_purchases, :organograms
    add_foreign_key :direct_purchases, :licitation_objects
    add_foreign_key :direct_purchases, :delivery_locations
    add_foreign_key :direct_purchases, :employees
    add_foreign_key :direct_purchases, :payment_methods
  end
end
