class CreateComprasPurchaseProcessAccreditations < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_accreditations do |t|
      t.integer  :licitation_process_id
      t.timestamps
    end

    add_index :compras_purchase_process_accreditations, :licitation_process_id,
              :name => :cppa_licitation_process_idx

    add_foreign_key :compras_purchase_process_accreditations, :compras_licitation_processes,
                    :column => :licitation_process_id, :name => :cppa_licitation_process_fk
  end
end
