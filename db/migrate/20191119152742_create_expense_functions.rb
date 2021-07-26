class CreateExpenseFunctions < ActiveRecord::Migration
  def change
    create_table :compras_expense_functions do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
