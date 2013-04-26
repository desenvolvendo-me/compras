class AddLotAndLicitationProcessToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    execute 'delete from compras_purchase_process_creditor_proposals'

    add_column :compras_purchase_process_creditor_proposals, :lot, :integer
    add_column :compras_purchase_process_creditor_proposals, :licitation_process_id, :integer, null: false

    add_index :compras_purchase_process_creditor_proposals, :licitation_process_id,
      name: :index_purc_proc_cred_prop_on_licitation_process_id

    add_foreign_key :compras_purchase_process_creditor_proposals, :compras_licitation_processes,
      column: :licitation_process_id, name: :purc_proc_cred_prop_licitation_process_fk

    change_column :compras_purchase_process_creditor_proposals, :purchase_process_item_id, :integer, null: true
    change_column :compras_purchase_process_creditor_proposals, :brand, :string, null: true
  end
end
