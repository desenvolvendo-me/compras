class CreateLicitationProcessesPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :compras_licitation_processes_purchase_solicitations, :id => false do |t|
      t.references :licitation_process, :null => false
      t.references :purchase_solicitation, :null => false
    end

    add_index :compras_licitation_processes_purchase_solicitations, :licitation_process_id,
      :name => "index_lic_procs_purc_solic_on_licitation_process_id"
    add_index :compras_licitation_processes_purchase_solicitations, :purchase_solicitation_id,
      :name => "index_lic_procs_purc_solic_on_purchase_solicitation_id"

    add_foreign_key :compras_licitation_processes_purchase_solicitations, :compras_licitation_processes,
      :column => :licitation_process_id, :name => :compras_lic_procs_purc_solic_licitation_process_id
    add_foreign_key :compras_licitation_processes_purchase_solicitations, :compras_purchase_solicitations,
      :column => :purchase_solicitation_id, :name => :compras_lic_procs_purc_solic_purchase_solicitation_id

    execute <<-SQL
      insert into
        compras_licitation_processes_purchase_solicitations
      select
        id, purchase_solicitation_id
      from
        compras_licitation_processes
      where
        purchase_solicitation_id is not null
    SQL
  end
end
