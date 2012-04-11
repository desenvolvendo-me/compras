class AddExpenseElementIdToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :expense_natures, :expense_element_id, :integer
    add_index :expense_natures, :expense_element_id
    add_foreign_key :expense_natures, :expense_elements
  end
end
