class CreateTableContractItemBalances < ActiveRecord::Migration
  def change
    create_table "compras_contract_item_balances" do |t|
      t.integer  "movable_id"
      t.string   "movable_type"
      t.integer  "purchase_process_id"
      t.integer  "purchase_solicitation_id"
      t.integer  "contract_id"
      t.integer  "creditor_id"
      t.integer  "material_id"
      t.boolean  "contract_balance"
      t.timestamps "created_at",       :null => false
    end

    add_foreign_key :compras_contract_item_balances, :compras_licitation_processes, column: :purchase_process_id
    add_foreign_key :compras_contract_item_balances, :compras_purchase_solicitations, column: :purchase_solicitation_id
    add_foreign_key :compras_contract_item_balances, :compras_contracts, column: :contract_id
    add_foreign_key :compras_contract_item_balances, :unico_creditors, column: :creditor_id
    # add_foreign_key :compras_contract_item_balances, :unico_materials, column: :material_id
  end
end
