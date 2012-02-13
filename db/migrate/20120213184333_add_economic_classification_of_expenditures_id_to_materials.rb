class AddEconomicClassificationOfExpendituresIdToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :economic_classification_of_expenditure_id, :integer
    add_index :materials, :economic_classification_of_expenditure_id
    add_foreign_key :materials, :economic_classification_of_expenditures
  end
end
