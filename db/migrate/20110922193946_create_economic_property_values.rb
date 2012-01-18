class CreateEconomicPropertyValues < ActiveRecord::Migration
  def change
    create_table :economic_property_values do |t|
      t.string :value
      t.references :economic_property_setting
      t.references :economic_registration

      t.timestamps
    end
    add_foreign_key :economic_property_values, :economic_property_settings
    add_foreign_key :economic_property_values, :economic_registrations
  end
end
