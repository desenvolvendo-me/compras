class AddUnicoCreditorToProposalDisqualification < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_disqualifications, :creditor_id, :integer

    add_index :compras_purchase_process_creditor_disqualifications, :creditor_id,
              name: :cppcd_creditor_id
    add_foreign_key :compras_purchase_process_creditor_disqualifications, :unico_creditors, column: :creditor_id,
                    name: :cppcd_creditor_fk
  end
end
