class AddIndexOnFieldCalculationIdOnDelayedCalculations < ActiveRecord::Migration
  def change
    add_index :delayed_calculations, :field_calculation_id
  end
end
