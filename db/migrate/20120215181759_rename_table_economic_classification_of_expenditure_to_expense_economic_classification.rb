class RenameTableEconomicClassificationOfExpenditureToExpenseEconomicClassification < ActiveRecord::Migration
  def change
    rename_table :economic_classification_of_expenditures, :expense_economic_classifications
  end
end
