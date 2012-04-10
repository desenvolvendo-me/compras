class AddExpenseCategoryIdToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :expense_natures, :expense_category_id, :integer
    add_index :expense_natures, :expense_category_id
    add_foreign_key :expense_natures, :expense_categories
  end
end
