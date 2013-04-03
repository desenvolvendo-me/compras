class AddLotToAdministrativeProcessBudgetAllocationItem < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocation_items, :lot, :integer
  end
end
