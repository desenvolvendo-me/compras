class TradingItemBid < Compras::Model
  attr_accessible :amount, :round, :bidder_id, :trading_item_id,
                  :disqualification_reason, :status

  has_enumeration_for :status, :with => TradingItemBidStatus

  belongs_to :trading_item
  belongs_to :bidder

  has_one :trading, :through => :trading_item

  delegate :minimum_reduction_percent, :minimum_reduction_percent?,
           :minimum_reduction_value, :minimum_reduction_value?,
           :licitation_process_id,
           :to => :trading_item, :allow_nil => true

  delegate :last_proposal_value,
           :to => :trading_item, :allow_nil => true, :prefix => true

  validates :round, :trading_item, :bidder, :amount, :presence => true
  validates :amount, :numericality => { :greater_than => 0 }

  validate  :bidder_is_part_of_trading
  validate  :amount_limit_by_percentage
  validate  :amount_limit_by_value

  def self.with_proposal
    where { status.eq(TradingItemBidStatus::WITH_PROPOSAL) }.order { :id }
  end

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

  def amount_limit_by_percentage(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless minimum_reduction_percent? && trading_item_last_proposal_value?

    if amount > minimum_percentage_value
      errors.add(:amount, :should_be_less_or_equals, :value => numeric_parser.localize(minimum_percentage_value))
    end
  end

  def amount_limit_by_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless minimum_reduction_value? && trading_item_last_proposal_value?

    if amount > minimum_value
      errors.add(:amount, :should_be_less_or_equals, :value => numeric_parser.localize(minimum_value))
    end
  end

  def minimum_value
    trading_item_last_proposal_value - minimum_reduction_value
  end

  def minimum_percentage_value
    trading_item_last_proposal_value - (trading_item_last_proposal_value * minimum_reduction_percentage)
  end

  def minimum_reduction_percentage
    minimum_reduction_percent / 100.0
  end

  def trading_item_last_proposal_value?
    trading_item_last_proposal_value > 0
  end
end
