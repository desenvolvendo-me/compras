class RenameTableFormulaCalculations < ActiveRecord::Migration
  def change
    rename_table :formula_calculations, :calculation_formulas
  end
end
