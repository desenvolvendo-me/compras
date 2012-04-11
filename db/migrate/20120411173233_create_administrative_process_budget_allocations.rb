class CreateAdministrativeProcessBudgetAllocations < ActiveRecord::Migration
  def change
    create_table :administrative_process_budget_allocations do |t|
      t.references :administrative_process
      t.references :budget_allocation
      t.decimal :value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :administrative_process_budget_allocations, :administrative_process_id, :name => 'apba_administrative_process_id'
    add_index :administrative_process_budget_allocations, :budget_allocation_id, :name => 'apba_budget_allocation_id'

    add_foreign_key :administrative_process_budget_allocations, :administrative_processes, :name => 'apba_administrative_process_fk'
    add_foreign_key :administrative_process_budget_allocations, :budget_allocations, :name => 'apba_budget_allocation_fk'
  end
end
