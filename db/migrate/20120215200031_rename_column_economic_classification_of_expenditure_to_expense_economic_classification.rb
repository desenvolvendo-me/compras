class RenameColumnEconomicClassificationOfExpenditureToExpenseEconomicClassification < ActiveRecord::Migration
  def change
    rename_column :expense_economic_classifications, :economic_classification_of_expenditure, :expense_economic_classification
  end
end
