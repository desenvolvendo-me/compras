class ChangeBudgetAllocationFromAdministrativeProcessToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocations, :licitation_process_id, :integer

    add_index :compras_administrative_process_budget_allocations,
              :licitation_process_id,
              :name => 'capba_licitation_process_idx'

    add_foreign_key :compras_administrative_process_budget_allocations,
                    :compras_licitation_processes,
                    :column => :licitation_process_id,
                    :name => 'capba_licitation_process_fk'

    execute <<-SQL
      UPDATE compras_administrative_process_budget_allocations a
      SET licitation_process_id = b.id
      FROM compras_licitation_processes b
      WHERE b.administrative_process_id = a.administrative_process_id
    SQL

    remove_column :compras_administrative_process_budget_allocations, :administrative_process_id

    execute <<-SQL
      DELETE FROM compras_administrative_process_budget_allocation_items a
      USING compras_administrative_process_budget_allocations b
      WHERE
        b.id = a.administrative_process_budget_allocation_id AND
        b.licitation_process_id IS NULL
    SQL

    execute <<-SQL
      DELETE FROM compras_administrative_process_budget_allocations
      WHERE licitation_process_id IS NULL
    SQL
  end
end
