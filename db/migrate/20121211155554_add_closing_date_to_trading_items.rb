class AddClosingDateToTradingItems < ActiveRecord::Migration
  def change
    add_column :compras_trading_items, :closing_date, :datetime
  end
end
