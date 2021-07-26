class CreateContractConsumptionMinute < ActiveRecord::Migration
  def change
    create_table :compras_contract_consumption_minutes do |t|
      t.integer :contract_id
      t.integer :purchase_solicitation_item_id
      t.integer :contract_quantity
      t.integer :contract_consumption
      t.timestamps
    end

    add_index :compras_contract_consumption_minutes, :contract_id, name: :contract_index
    add_index :compras_contract_consumption_minutes, :purchase_solicitation_item_id, name: :solicitation_item_index

    add_foreign_key :compras_contract_consumption_minutes, :compras_contracts,
                    column: :contract_id, name: :contract_fk
    add_foreign_key :compras_contract_consumption_minutes, :compras_purchase_solicitation_items,
                    column: :purchase_solicitation_item_id, name: :solicitation_item_fk
  end
end
