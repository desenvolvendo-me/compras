class AddExpenseModalityIdToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :expense_natures, :expense_modality_id, :integer
    add_index :expense_natures, :expense_modality_id
    add_foreign_key :expense_natures, :expense_modalities
  end
end
