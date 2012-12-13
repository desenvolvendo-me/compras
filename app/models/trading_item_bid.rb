class TradingItemBid < Compras::Model
  attr_accessible :amount, :round, :bidder_id, :trading_item_id,
                  :disqualification_reason, :status, :stage

  has_enumeration_for :stage, :with => TradingItemBidStage,
                      :create_helpers => true, :create_scopes => true
  has_enumeration_for :status, :with => TradingItemBidStatus,
                      :create_helpers => true

  belongs_to :trading_item
  belongs_to :bidder

  has_one  :trading, :through => :trading_item

  delegate :minimum_reduction_percent, :minimum_reduction_percent?,
           :minimum_reduction_value, :minimum_reduction_value?,
           :licitation_process_id,
           :to => :trading_item, :allow_nil => true

  delegate :lowest_proposal_value,
           :to => :trading_item, :allow_nil => true, :prefix => true

  validates :round, :trading_item, :bidder, :status, :presence => true
  validates :amount, :presence => true, :if => :with_proposal?
  validates :amount, :numericality => { :greater_than => 0 }, :if => :with_proposal?
  validates :disqualification_reason, :presence => true, :if => :disqualified?
  validates :round, :numericality => { :greater_than => 0 }, :if => :round_of_bids?
  validates :round, :numericality => { :equal_to => 0 }, :unless => :round_of_bids?

  validate  :bidder_is_part_of_trading
  validate  :amount_limit_by_percentage, :if => :with_proposal?
  validate  :amount_limit_by_value, :if => :with_proposal?
  validate  :amount_limit_on_negotiation, :if => :validate_amount_on_negotiation?

  scope :at_stage_of_proposals, lambda { where { stage.eq(TradingItemBidStage::PROPOSALS)} }
  scope :at_stage_of_round_of_bids, lambda { where { stage.eq(TradingItemBidStage::ROUND_OF_BIDS)} }
  scope :at_round, lambda { |round_number| where { round.eq(round_number) } }
  scope :for_trading_item, lambda { |item_id| where { trading_item_id.eq(item_id) } }

  def self.with_proposal
    where { status.eq(TradingItemBidStatus::WITH_PROPOSAL) }.order { :id }
  end

  def self.with_valid_proposal
    enabled.with_proposal
  end

  def self.enabled
    joins { bidder }.where { bidder.disabled.eq(false) }
  end

  def self.with_no_proposal
    where { status.not_eq(TradingItemBidStatus::WITH_PROPOSAL) }.order { :id }
  end

  def update_status(new_status)
    update_column(:status, new_status)
  end

  def minimum_limit
    if negotiation?
      minimum_value_on_negotiation
    elsif minimum_reduction_percent?
      minimum_percentage_value_rounded
    else
      minimum_value
    end
  end

  private

  def minimum_value_on_negotiation
    trading_item_lowest_proposal_value - 0.01
  end

  def validate_amount_on_negotiation?
    with_proposal? && negotiation?
  end

  def bidder_is_part_of_trading
    return unless bidder.present?

    if bidder.licitation_process_id != licitation_process_id
      errors.add(:bidder, :should_be_part_of_trading)
    end
  end

  def amount_limit_by_percentage(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless validate_amount_limit_by_percentage?

    if amount > minimum_percentage_value_rounded
      errors.add(:amount, :less_than_or_equal_to, :count => numeric_parser.localize(minimum_percentage_value_rounded))
    end
  end

  def validate_amount_limit_by_percentage?
    validate_amount_limit? && minimum_reduction_percent?
  end

  def amount_limit_by_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless validate_amount_limit_by_value?

    if amount > minimum_value
      errors.add(:amount, :less_than_or_equal_to, :count => numeric_parser.localize(minimum_value))
    end
  end

  def amount_limit_on_negotiation(numeric_parser = ::I18n::Alchemy::NumericParser)
    if amount > minimum_limit
      errors.add(:amount, :less_than_or_equal_to, :count => numeric_parser.localize(minimum_limit))
    end
  end

  def validate_amount_limit_by_value?
    validate_amount_limit? && minimum_reduction_value?
  end

  def validate_amount_limit?
    amount && trading_item_lowest_proposal_value? && round_of_bids?
  end

  def minimum_value
    return BigDecimal(0) unless trading_item_lowest_proposal_value?

    trading_item_lowest_proposal_value - minimum_reduction_value
  end

  def minimum_percentage_value_rounded
    minimum_percentage_value.round(2)
  end

  def minimum_percentage_value
    trading_item_lowest_proposal_value - (trading_item_lowest_proposal_value * minimum_reduction_percentage)
  end

  def minimum_reduction_percentage
    minimum_reduction_percent / BigDecimal(100)
  end

  def trading_item_lowest_proposal_value?
    trading_item_lowest_proposal_value > 0
  end
end
