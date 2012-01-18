class ChangeValueTypeOnPropertyCorrectionFactorValues < ActiveRecord::Migration
  def up
    execute "UPDATE property_correction_factor_values SET value = replace(value, ',', '.')"
    change_column :property_correction_factor_values, :value, :decimal, :precision => 5, :scale => 2
  end

  def down
    change_column :property_correction_factor_values, :value, :string
  end
end
