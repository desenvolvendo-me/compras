class RenameColumnMaterialsEconomicClassificationOfExpenditureIdToExpenseEconomicClassificationId < ActiveRecord::Migration
  def change
    rename_column :materials, :economic_classification_of_expenditure_id, :expense_economic_classification_id
  end
end
