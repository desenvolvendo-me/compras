class CreatePurchaseProcessCreditorDisqualifications < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_creditor_disqualifications do |t|
      t.belongs_to :licitation_process, null: false
      t.belongs_to :creditor, null: false
      t.date :disqualification_date, null: false
      t.text :reason, null: false
      t.string :kind, null: false
      t.timestamps
    end

    add_foreign_key :compras_purchase_process_creditor_disqualifications, :compras_licitation_processes,
      name: :purc_proc_cred_disq_licitation_process_fk, column: :licitation_process_id
    add_foreign_key :compras_purchase_process_creditor_disqualifications, :compras_creditors,
      name: :purc_proc_cred_disq_creditor_fk, column: :creditor_id

    add_index :compras_purchase_process_creditor_disqualifications, :licitation_process_id,
      name: :index_purc_proc_cred_disq_on_licitation_process_id
    add_index :compras_purchase_process_creditor_disqualifications, :creditor_id,
      name: :index_purc_proc_cred_disq_on_creditor_id
  end
end
