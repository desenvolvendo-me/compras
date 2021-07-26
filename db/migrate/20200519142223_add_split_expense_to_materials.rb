class AddSplitExpenseToMaterials < ActiveRecord::Migration
  def change
    add_column :unico_materials, :split_expense_id, :integer
    add_index :unico_materials, :split_expense_id
    # add_foreign_key :unico_materials, :compras_split_expenses, column: :split_expense_id
  end
end