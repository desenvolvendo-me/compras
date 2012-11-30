class AddPurchaseSolicitationIdToComprasAdministrativeProcesses < ActiveRecord::Migration
  def change
    add_column :compras_administrative_processes, :purchase_solicitation_id, :integer

    add_index :compras_administrative_processes, :purchase_solicitation_id,
              :name => :cap_purchase_solicitation_id_idx
    add_foreign_key :compras_administrative_processes, :compras_purchase_solicitations,
                    :column => :purchase_solicitation_id, :name => :cap_purchase_solicitation_id_fk
  end
end
