class AddExpenseSplitToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :expense_natures, :expense_split, :string
  end
end
