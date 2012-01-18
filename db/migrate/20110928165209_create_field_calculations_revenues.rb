class CreateFieldCalculationsRevenues < ActiveRecord::Migration
  def change
    create_table :field_calculations_revenues, :id => false do |t|
      t.integer :field_calculation_id
      t.integer :revenue_id
    end

    add_foreign_key :field_calculations_revenues, :field_calculations
    add_foreign_key :field_calculations_revenues, :revenues
  end
end
