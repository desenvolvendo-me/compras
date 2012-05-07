class AddLicitationProcessLotToAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    add_column :administrative_process_budget_allocation_items, :licitation_process_lot_id, :integer

    add_index :administrative_process_budget_allocation_items, :licitation_process_lot_id, :name => 'apbai_licitation_process_lot_id'
    add_foreign_key :administrative_process_budget_allocation_items, :licitation_process_lots, :name => 'apbai_licitation_process_lot_fk'
  end
end
