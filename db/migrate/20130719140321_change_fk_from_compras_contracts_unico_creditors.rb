class ChangeFkFromComprasContractsUnicoCreditors < ActiveRecord::Migration
  def change
    remove_foreign_key :compras_contracts_unico_creditors,  name: :ccuc_creditor_fk
    add_foreign_key :compras_contracts_unico_creditors, :unico_creditors,
                    column: :creditor_id, name: :ccuc_creditor_fk
  end
end
