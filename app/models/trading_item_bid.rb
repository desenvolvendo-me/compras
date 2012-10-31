class TradingItemBid < Compras::Model
  attr_accessible :amount, :round, :bidder_id, :trading_item_id

  belongs_to :trading_item
  belongs_to :bidder

  delegate :trading, :licitation_process_id, :to => :trading_item,
           :allow_nil => true

  validates :round, :trading_item, :bidder, :amount, :presence => true
  validates :amount, :numericality => { :greater_than => 0 }

  validate  :bidder_is_part_of_trading

  private

  def bidder_is_part_of_trading
    return unless bidder.present?
    
    if bidder.licitation_process_id != licitation_process_id
      errors.add(:bidder, :should_be_part_of_trading)
    end
  end
end
