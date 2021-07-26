class AddQuantityToContractItemBalance < ActiveRecord::Migration
  def change
    add_column :compras_contract_item_balances, :quantity, :integer
  end
end
