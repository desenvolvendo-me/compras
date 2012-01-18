class CreateFormulaCalculations < ActiveRecord::Migration
  def change
    create_table :formula_calculations do |t|
      t.integer :year
      t.string :name
      t.string :procedure

      t.timestamps
    end
  end
end
