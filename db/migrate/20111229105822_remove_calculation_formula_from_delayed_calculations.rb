class RemoveCalculationFormulaFromDelayedCalculations < ActiveRecord::Migration
  def change
    remove_column :delayed_calculations, :calculation_formula_id
  end
end
