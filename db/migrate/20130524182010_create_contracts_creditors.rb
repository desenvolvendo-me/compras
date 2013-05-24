class CreateContractsCreditors < ActiveRecord::Migration
  def up
    create_table :compras_contracts_creditors, id: false do |t|
      t.references :contract
      t.references :creditor
    end

    add_foreign_key :compras_contracts_creditors, :compras_contracts, column: :contract_id
    add_foreign_key :compras_contracts_creditors, :compras_creditors, column: :creditor_id

    add_index :compras_contracts_creditors, :contract_id
    add_index :compras_contracts_creditors, :creditor_id
  end

  def down
    drop_table :compras_contracts_creditors
  end
end
