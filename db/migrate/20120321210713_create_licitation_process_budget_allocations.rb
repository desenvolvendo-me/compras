class CreateLicitationProcessBudgetAllocations < ActiveRecord::Migration
  def change
    create_table :licitation_process_budget_allocations do |t|
      t.references :licitation_process
      t.references :budget_allocation
      t.decimal :estimated_value, :precision => 10, :scale => 2
      t.string :pledge_type

      t.timestamps
    end

    add_index :licitation_process_budget_allocations, :licitation_process_id, :name => 'lpba_licitation_process_id'
    add_index :licitation_process_budget_allocations, :budget_allocation_id, :name => 'lpba_budget_allocation_id'
    add_foreign_key :licitation_process_budget_allocations, :licitation_processes, :name => 'lpba_licitation_process_fk'
    add_foreign_key :licitation_process_budget_allocations, :budget_allocations, :name => 'lpba_budget_allocation_fk'
  end
end
