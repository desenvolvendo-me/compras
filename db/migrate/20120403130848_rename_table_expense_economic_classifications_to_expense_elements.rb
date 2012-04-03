class RenameTableExpenseEconomicClassificationsToExpenseElements < ActiveRecord::Migration
  def up
    rename_table :expense_economic_classifications, :expense_elements

    rename_column :expense_elements, :expense_economic_classification, :expense_element

    rename_column :purchase_solicitations, :expense_economic_classification_id, :expense_element_id
    rename_column :purchase_solicitation_budget_allocations, :expense_economic_classification_id, :expense_element_id
    rename_column :materials, :expense_economic_classification_id, :expense_element_id
    rename_column :budget_allocations, :expense_economic_classification_id, :expense_element_id
  end
end
