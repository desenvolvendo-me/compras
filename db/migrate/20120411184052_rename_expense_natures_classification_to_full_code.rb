class RenameExpenseNaturesClassificationToFullCode < ActiveRecord::Migration
  def change
    rename_column :expense_natures, :classification, :full_code
  end
end
