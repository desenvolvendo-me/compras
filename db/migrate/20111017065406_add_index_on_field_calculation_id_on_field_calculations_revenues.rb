class AddIndexOnFieldCalculationIdOnFieldCalculationsRevenues < ActiveRecord::Migration
  def change
    add_index :field_calculations_revenues, :field_calculation_id
  end
end
