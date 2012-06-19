class RenameExpenseNaturesFullCodeToExpenseNature < ActiveRecord::Migration
  def change
    rename_column :compras_expense_natures, :full_code, :expense_nature
  end
end
