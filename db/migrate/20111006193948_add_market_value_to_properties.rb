class AddMarketValueToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :market_value, :decimal, :precision => 10, :scale => 2
  end
end
