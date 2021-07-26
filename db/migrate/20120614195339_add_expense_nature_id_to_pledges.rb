class AddExpenseNatureIdToPledges < ActiveRecord::Migration
  def change
    add_column :compras_pledges, :expense_nature_id, :integer
    add_index :compras_pledges, :expense_nature_id
    add_foreign_key :compras_pledges, :compras_expense_natures, :column => :expense_nature_id
  end
end
