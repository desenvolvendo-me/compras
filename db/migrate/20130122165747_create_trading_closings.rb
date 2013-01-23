class CreateTradingClosings < ActiveRecord::Migration
  def change
    create_table :compras_trading_closings do |t|
      t.references :trading
      t.string :status
      t.text :observation

      t.timestamps
    end

    add_index :compras_trading_closings, :trading_id
    add_foreign_key :compras_trading_closings, :compras_tradings, :column => :trading_id
  end
end
