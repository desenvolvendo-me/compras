class AddIndexOnPropertyCorrectionFactorIdOnPropertyCorrectionFactorValues < ActiveRecord::Migration
  def change
    add_index :property_correction_factor_values, :property_correction_factor_id, :name => :index_property_correction_factor_id
  end
end
