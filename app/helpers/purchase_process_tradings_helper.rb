# encoding: utf-8
module PurchaseProcessTradingsHelper
  def make_bid_disabled_message(next_bid)
    t('purchase_process_trading.messages.make_bid_disabled_message') if next_bid.blank?
  end

  def undo_bid_disabled_message(historic)
    t('purchase_process_trading.messages.undo_bid_disabled_message') if historic.empty?
  end
end
