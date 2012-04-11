class AddExpenseGroupIdToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :expense_natures, :expense_group_id, :integer
    add_index :expense_natures, :expense_group_id
    add_foreign_key :expense_natures, :expense_groups
  end
end
