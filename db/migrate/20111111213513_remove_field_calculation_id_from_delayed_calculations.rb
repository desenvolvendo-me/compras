class RemoveFieldCalculationIdFromDelayedCalculations < ActiveRecord::Migration
  def change
    remove_column :delayed_calculations, :field_calculation_id
  end
end
