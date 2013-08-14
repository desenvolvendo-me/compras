module PurchaseProcessTradingsHelper
  def make_bid_disabled_message(next_bid)
    t('purchase_process_trading.messages.make_bid_disabled_message') if next_bid.blank?
  end

  def undo_bid_disabled_message(historic)
    t('purchase_process_trading.messages.undo_bid_disabled_message') if historic.empty?
  end

  def amount_with_reduction(next_bid)
    return '0,00' unless next_bid.respond_to?(:decorator)

    next_bid.decorator.amount_with_reduction
  end
end
