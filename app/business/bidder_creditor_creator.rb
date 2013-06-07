class BidderCreditorCreator
  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @trading_item_winner = options.fetch(:trading_item_winner) { TradingItemWinner }
  end

  def self.create!(*params)
    new(*params).create_bidders!
  end

  def create_bidders!
    return unless bidders.empty?

    create_bidders_for_direct_purchase
    create_bidders_for_trading
  end

  private

  attr_reader :purchase_process, :trading_item_winner

  def create_bidders_for_trading
    return unless purchase_process.trading?

    trading_items.each do |item|
      bidders.create!(licitation_process_id: purchase_process.id, creditor_id: trading_item_winner_creditor_id(item))
    end
  end

  def create_bidders_for_direct_purchase
    return unless purchase_process.direct_purchase?

    items.each  do |item|
      bidders.create!(licitation_process_id: purchase_process.id, creditor_id: item.creditor.id)
    end
  end

  def items
    purchase_process.items
  end

  def bidders
    purchase_process.bidders
  end

  def trading
    purchase_process.trading
  end

  def trading_items
    trading.items.closed
  end

  def trading_item_winner_creditor_id(item)
    trading_item_winner.new(item).creditor.id
  end
end
