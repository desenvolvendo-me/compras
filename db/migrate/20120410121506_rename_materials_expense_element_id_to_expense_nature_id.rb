class RenameMaterialsExpenseElementIdToExpenseNatureId < ActiveRecord::Migration
  def change
    rename_column :materials, :expense_element_id, :expense_nature_id
  end
end
