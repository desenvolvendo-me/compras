class CreatePropertyCorrectionFactors < ActiveRecord::Migration
  def change
    create_table :property_correction_factors do |t|
      t.integer :year
      t.references :property_variable_setting
      t.decimal :value, :precision => 5, :scale => 2

      t.timestamps
    end
    add_index :property_correction_factors, :property_variable_setting_id, :name => 'index_property_correction_factors_on_property_variable_setting'
    add_foreign_key :property_correction_factors, :property_variable_settings
  end
end
