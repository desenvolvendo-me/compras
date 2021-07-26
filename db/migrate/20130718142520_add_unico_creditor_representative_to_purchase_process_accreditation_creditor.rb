class AddUnicoCreditorRepresentativeToPurchaseProcessAccreditationCreditor < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_accreditation_creditors, :creditor_representative_id, :integer

    add_index :compras_purchase_process_accreditation_creditors, :creditor_representative_id,
              name: :cppac_creditor_representative_id
    add_foreign_key :compras_purchase_process_accreditation_creditors, :unico_creditor_representatives,
                    column: :creditor_representative_id, name: :cppac_creditor_representative_fk
  end
end
