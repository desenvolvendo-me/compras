class RenameExpenseElementsToExpenseNatures < ActiveRecord::Migration
  def change
    rename_table :expense_elements, :expense_natures
  end
end
