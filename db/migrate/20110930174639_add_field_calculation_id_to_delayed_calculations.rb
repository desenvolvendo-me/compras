class AddFieldCalculationIdToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :field_calculation_id, :integer
    add_foreign_key :delayed_calculations, :field_calculations
  end
end
