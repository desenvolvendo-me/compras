class AddTradingRegistryToTrading < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :trading_registry, :text
  end
end
