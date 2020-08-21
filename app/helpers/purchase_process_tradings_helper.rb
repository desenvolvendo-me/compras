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

  def get_creditor_status item, accreditation_creditor, historic
    winner = item.creditor_winner
    return 'Vencedor' if winner.try(:id) == accreditation_creditor.creditor_id
    historic.where(purchase_process_accreditation_creditor_id: accreditation_creditor).try(:first).try(:status_humanize)
  end

  def order_creditor accreditation_creditor, item
    winner = item.creditor_winner
    accreditation_creditor.sort_by{|x| x.creditor_id == winner.try(:id) ? 0 : 1}
  end
end
