class AddBalanceToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :balance, :boolean
  end
end
