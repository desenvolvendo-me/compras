class AddEconomicClassificationOfExpenditureIdToPurchaseSolicitations < ActiveRecord::Migration
  def change
    add_column :purchase_solicitations, :economic_classification_of_expenditure_id, :integer
    add_index :purchase_solicitations, :economic_classification_of_expenditure_id, :name => 'index_ps_economic_classification_of_expenditure'
    add_foreign_key :purchase_solicitations, :economic_classification_of_expenditures, :name => 'ps_economic_classification_of_expenditure_fk'
  end
end
