class AddUnicoCreditorToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :creditor_id, :integer

    add_index :compras_purchase_process_creditor_proposals, :creditor_id,
              name: :cppcp_creditor_id
    add_foreign_key :compras_purchase_process_creditor_proposals, :unico_creditors, column: :creditor_id,
                    name: :cppcp_creditor_fk
  end
end
