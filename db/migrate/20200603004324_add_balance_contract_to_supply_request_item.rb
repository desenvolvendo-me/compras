class AddBalanceContractToSupplyRequestItem < ActiveRecord::Migration
  def change
    add_column :compras_supply_request_items, :balance_contract, :boolean
  end
end
