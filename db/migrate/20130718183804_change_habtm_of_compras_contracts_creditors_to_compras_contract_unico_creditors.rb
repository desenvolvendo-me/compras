class ChangeHabtmOfComprasContractsCreditorsToComprasContractUnicoCreditors < ActiveRecord::Migration
  def change
    rename_table :compras_contracts_creditors, :compras_contracts_unico_creditors
    remove_column :compras_contracts_unico_creditors, :creditor_id
    add_column :compras_contracts_unico_creditors, :creditor_id, :integer

    add_index :compras_contracts_unico_creditors, :creditor_id, name: :ccuc_creditor_id
    add_foreign_key :compras_contracts_unico_creditors, :unico_document_types,
                    column: :creditor_id, name: :ccuc_creditor_fk
  end
end
