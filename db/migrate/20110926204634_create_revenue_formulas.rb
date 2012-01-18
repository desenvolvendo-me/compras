class CreateRevenueFormulas < ActiveRecord::Migration
  def change
    create_table :revenue_formulas do |t|
      t.string :name
      t.references :revenue
      t.references :formula_calculation

      t.timestamps
    end
    add_index :revenue_formulas, :revenue_id
    add_index :revenue_formulas, :formula_calculation_id
    add_foreign_key :revenue_formulas, :revenues
    add_foreign_key :revenue_formulas, :formula_calculations
  end
end
