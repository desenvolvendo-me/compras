class RemoveClosingDateFromComprasTradingItems < ActiveRecord::Migration
  class TradingItem < Compras::Model;end
  class TradingItemClosing < Compras::Model;end

  def change
    TradingItem.find_each do |item|
      if item.closing_date
        TradingItemClosing.create!(
          :trading_item_id => item.id,
          :status => TradingItemClosingStatus::WINNER)
      end
    end

    remove_column :compras_trading_items, :closing_date
  end
end
