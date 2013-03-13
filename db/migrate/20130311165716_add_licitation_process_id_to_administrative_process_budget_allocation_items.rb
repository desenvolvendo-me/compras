class AddLicitationProcessIdToAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    add_column :compras_administrative_process_budget_allocation_items, :licitation_process_id, :integer

    add_index  :compras_administrative_process_budget_allocation_items, :licitation_process_id,
      :name => :index_compras_adm_proc_bgt_alloc_items_on_licitation_process_id

    add_foreign_key :compras_administrative_process_budget_allocation_items, :compras_licitation_processes,
      :column => :licitation_process_id, :name => :compras_adm_proc_bgt_alloc_items_licitation_process_id

    begin
      AdministrativeProcessBudgetAllocationItem.reset_column_information

      execute <<-SQL
        update compras_administrative_process_budget_allocation_items c
        set    licitation_process_id = (
          select  licitation_process_id
          from    compras_administrative_process_budget_allocations co
          where   co.id = c.id
        )
      SQL
    rescue NameError
      puts "AdministrativeProcessBudgetAllocationItem class doesn't exist anymore\nSkiping migration..."
    end
  end
end
