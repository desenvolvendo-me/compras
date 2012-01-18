class CreatePropertyCorrectionFactorValues < ActiveRecord::Migration
  def change
    create_table :property_correction_factor_values do |t|
      t.string :value
      t.references :property_correction_factor
      t.references :property_variable_setting_option

      t.timestamps
    end

    add_foreign_key :property_correction_factor_values, :property_correction_factors, :name => :correction_factors
    add_foreign_key :property_correction_factor_values, :property_variable_setting_options, :name => :variable_setting_options
  end
end
