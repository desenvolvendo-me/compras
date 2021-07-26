class AddContractToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders,
               :contract_id, :integer
    add_index :compras_supply_orders, :contract_id
    add_foreign_key :compras_supply_orders, :compras_contracts,
                    :column => :contract_id
    end
end
