class CreateSplitExpenses < ActiveRecord::Migration
  def change
    create_table :compras_split_expenses do |t|
      t.string :code
      t.string :description
      t.text :function_account
      t.references :nature_expense

      t.timestamps
    end
    add_index :compras_split_expenses, :nature_expense_id
    add_foreign_key :compras_split_expenses, :compras_nature_expenses,
                    column: :nature_expense_id
  end
end
