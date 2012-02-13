class AddPurchaseSolicitationBudgetAllocationsEconomicClassificationOfExpenditure < ActiveRecord::Migration
  def up
    add_column :purchase_solicitation_budget_allocations, :economic_classification_of_expenditure_id, :integer
    add_index :purchase_solicitation_budget_allocations, :economic_classification_of_expenditure_id, :name => 'index_psba_economic_classification_of_expenditure'
    add_foreign_key :purchase_solicitation_budget_allocations, :economic_classification_of_expenditures, :name => 'psba_economic_classification_of_expenditure_fk'
  end
end
