module PurchaseProcessTradingsHelper
  def make_bid_disabled_message(bids)
    t('purchase_process_trading.messages.make_bid_disabled_message') if bids.any?(&:declined?)
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

  def link_to_lot trading, item
    purchase_item = trading.purchase_process.purchase_solicitations.map{|x| x.purchase_solicitation.items.where(lot: item.lot).first }[0] rescue nil
    purchase_solicitation_id = purchase_item.try(:purchase_solicitation_id)

    if purchase_solicitation_id
      link_to 'Visualizar', edit_purchase_solicitation_path(purchase_solicitation_id), style: 'font-size: 12px'
    end
  end
end
