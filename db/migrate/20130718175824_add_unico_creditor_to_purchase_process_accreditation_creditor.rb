class AddUnicoCreditorToPurchaseProcessAccreditationCreditor < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_accreditation_creditors, :creditor_id, :integer

    add_index :compras_purchase_process_accreditation_creditors, :creditor_id,
              name: :cppac_creditor_id
    add_foreign_key :compras_purchase_process_accreditation_creditors, :unico_creditors, column: :creditor_id,
                    name: :cppac_creditor_fk
  end
end
