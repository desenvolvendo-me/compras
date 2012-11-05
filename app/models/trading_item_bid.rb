class TradingItemBid < Compras::Model
  attr_accessible :amount, :round, :bidder_id, :trading_item_id,
                  :disqualification_reason

  has_enumeration_for :status, :with => TradingItemBidStatus

  belongs_to :trading_item
  belongs_to :bidder

  delegate :trading, :licitation_process_id, :to => :trading_item,
           :allow_nil => true

  validates :round, :trading_item, :bidder, :amount, :presence => true
  validates :amount, :numericality => { :greater_than => 0 }

  validate  :bidder_is_part_of_trading

  def update_status(new_status)
    update_column(:status, new_status)
  end

  private

  def bidder_is_part_of_trading
    return unless bidder.present?

    if bidder.licitation_process_id != licitation_process_id
      errors.add(:bidder, :should_be_part_of_trading)
    end
  end
end
