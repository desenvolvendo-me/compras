class RenameColumnFormulaCalculationIdInRevenueFormulas < ActiveRecord::Migration
  def change
    rename_column :revenue_formulas, :formula_calculation_id, :calculation_formula_id
  end
end
