class RemoveMarketValueFromProperty < ActiveRecord::Migration
  def change
    remove_column :properties, :market_value
  end
end
