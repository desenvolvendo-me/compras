class AddInformationToAdministrativeProcessBudgetAllocationItem < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocation_items, :additional_information, :text
  end
end
