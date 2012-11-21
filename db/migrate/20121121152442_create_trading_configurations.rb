class CreateTradingConfigurations < ActiveRecord::Migration
  def change
    create_table :compras_trading_configurations do |t|
      t.decimal :percentage_limit_to_participate_in_bids, :precision => 5, :scale => 2, :default => 0.0

      t.timestamps
    end
  end
end
