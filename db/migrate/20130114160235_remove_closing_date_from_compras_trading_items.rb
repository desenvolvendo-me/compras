class RemoveClosingDateFromComprasTradingItems < ActiveRecord::Migration
  def change
    TradingItem.find_each do |item|
      TradingItemClosing.create!(
        :trading_item_id => item.id,
        :status => TradingItemClosingStatus::WINNER)
    end

    remove_column :compras_trading_items, :closing_date
  end
end
