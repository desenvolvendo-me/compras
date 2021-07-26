class CreatePurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_creditor_proposals do |t|
      t.references :creditor, null: false
      t.references :administrative_process_budget_allocation_item, null: false
      t.string :brand, null: false
      t.decimal :unit_price, precision: 10, scale: 2, default: 0.0, null: false
      t.timestamps
    end

    add_foreign_key :compras_purchase_process_creditor_proposals, :compras_creditors,
      name: :purc_proc_cred_prop_creditor_fk, column: :creditor_id
    add_foreign_key :compras_purchase_process_creditor_proposals, :compras_administrative_process_budget_allocation_items,
      name: :purc_proc_cred_prop_item_fk, column: :administrative_process_budget_allocation_item_id

    add_index :compras_purchase_process_creditor_proposals, :creditor_id,
      name: :index_purc_proc_cred_prop_on_creditor_id
    add_index :compras_purchase_process_creditor_proposals, :administrative_process_budget_allocation_item_id,
      name: :index_purc_proc_cred_prop_on_admi_proc_budg_allo_item_id
  end
end
