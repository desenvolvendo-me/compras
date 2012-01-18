class CreateEconomicPropertySettings < ActiveRecord::Migration
  def change
    create_table :economic_property_settings do |t|
      t.string :name
      t.integer :year
      t.references :type_item_economic_property_setting
      t.integer :order
      t.boolean :required, :default => false
      t.references :reference_unit

      t.timestamps
    end
    add_index :economic_property_settings, :type_item_economic_property_setting_id, :name => 'type_item_economic_param'
    add_index :economic_property_settings, :reference_unit_id
    add_foreign_key :economic_property_settings, :type_item_economic_property_settings, :name => 'type_item_economic_param'
    add_foreign_key :economic_property_settings, :reference_units
  end
end
