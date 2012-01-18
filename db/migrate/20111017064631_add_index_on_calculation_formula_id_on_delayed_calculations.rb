class AddIndexOnCalculationFormulaIdOnDelayedCalculations < ActiveRecord::Migration
  def change
    add_index :delayed_calculations, :calculation_formula_id
  end
end
