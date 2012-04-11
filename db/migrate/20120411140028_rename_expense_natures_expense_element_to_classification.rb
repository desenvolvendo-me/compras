class RenameExpenseNaturesExpenseElementToClassification < ActiveRecord::Migration
  def change
    rename_column :expense_natures, :expense_element, :classification
  end
end
