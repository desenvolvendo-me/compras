class PurchaseProcessTradingItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def lowest_bid_amount
    return '-' unless lowest_bid.present?

    number_with_precision lowest_bid.amount
  end

  def lowest_bid_creditor
    return '-' unless lowest_bid.present?

    lowest_bid.accreditation_creditor
  end

  def lowest_proposal_amount
    return '-' unless lowest_proposal

    number_with_precision lowest_proposal.unit_price
  end

  def lowest_proposal_creditor
    return '-' unless lowest_proposal

    lowest_proposal.creditor
  end

  def lowest_bid_or_proposal_amount
    number_with_delimiter super
  end

  def total_price
    return '-' unless lowest_proposal

    total = lowest_proposal.unit_price * quantity

    number_with_precision total
  end

  def reduction_rate_value
    number_with_precision(super) || '0,00'
  end

  def reduction_rate_percent
    number_with_precision(super) || '0,00'
  end

  def creditors_benefited
    creditors = []

    super.each_with_index do |creditor, index|
      creditors << ["#{index.succ} lugar - #{creditor}", creditor.id]
    end

    creditors
  end

  def benefited_bid_message
    if pending?
      I18n.t 'purchase_process_trading_item.messages.trading_item_not_finished'
    elsif closed? && !benefited_tie?
      I18n.t 'purchase_process_trading_item.messages.lowest_proposal_already_benefited'
    end
  end

  def item_or_lot
    if lot?
      'Lote ' + lot.to_s
    else
      item
    end
  end

  def item_id_or_lot
    if lot?
      lot
    else
      item.id
    end
  end
end
