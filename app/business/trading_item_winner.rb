class TradingItemWinner
  def initialize(item, options = {})
    @item = item
    @next_bid_calculator = options.fetch(:next_bid_calculator) { NextBidCalculator }
  end

  def creditor
    return unless trading_for_item_finished?(item)

    lowest_creditor
  end

  def amount
    return unless trading_for_item_finished?(item)

    lowest_amount
  end

  private

  attr_reader :item, :next_bid_calculator

  # determina se os lances para o item foram finalizados
  # se possui somente um lance dentre todos com o status with_proposal
  def trading_for_item_finished?(item)
    bids = item.bids.reload.reorder{id.desc}
    return if bids.blank?

    lastBids = []
    item.creditors_ordered.to_a.uniq(&:id).each do |creditor|
      lastBids << bids.detect{|i| i.purchase_process_accreditation_creditor_id == creditor.id}
    end

    lastBids.reject(&:nil?).one?(&:with_proposal?)
  end

  def lowest_creditor
    item.negotiation.try(:creditor) || item.lowest_bid.try(:creditor) || item.lowest_proposal.try(:creditor)
  end

  def lowest_amount
    item.negotiation.try(:amount) || item.lowest_bid.try(:amount) || item.lowest_proposal.try(:unit_price)
  end
end
