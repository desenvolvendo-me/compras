class CreateExpenseSubFunctions < ActiveRecord::Migration
  def change
    create_table :compras_expense_sub_functions do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
