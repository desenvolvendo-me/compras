class CreateDelayedCalculations < ActiveRecord::Migration
  def change
    create_table :delayed_calculations do |t|
      t.string :year
      t.integer :revenue_id
      t.integer :calculation_formula_id
      t.integer :origin
      t.integer :status
      t.boolean :simulated

      t.timestamps
    end

    add_foreign_key :delayed_calculations, :revenues
    add_foreign_key :delayed_calculations, :calculation_formulas
  end
end
