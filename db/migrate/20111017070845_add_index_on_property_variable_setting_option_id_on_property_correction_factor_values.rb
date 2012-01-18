class AddIndexOnPropertyVariableSettingOptionIdOnPropertyCorrectionFactorValues < ActiveRecord::Migration
  def change
    add_index :property_correction_factor_values, :property_variable_setting_option_id, :name => :index_property_variable_setting_option_id
  end
end
