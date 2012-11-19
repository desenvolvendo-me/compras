class TradingItem < Compras::Model
  attr_accessible :detailed_description, :minimum_reduction_percent,
                  :minimum_reduction_value, :order,
                  :administrative_process_budget_allocation_item_id

  belongs_to :trading
  belongs_to :administrative_process_budget_allocation_item

  has_many :trading_item_bids, :dependent => :destroy, :order => :id
  has_many :bidders, :through => :trading, :order => :id

  validates :minimum_reduction_percent, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_value?
  validates :minimum_reduction_value, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_percent?
  validates :minimum_reduction_percent, :numericality => { :less_than_or_equal_to => 100 }

  validate :require_at_least_one_minimum_reduction

  delegate :material, :material_id, :reference_unit,
           :quantity, :unit_price, :to_s,
           :to => :administrative_process_budget_allocation_item,
           :allow_nil => true
  delegate :licitation_process_id, :to => :trading

  orderize :order

  def last_proposal_value
    last_bid_with_proposal.try(:amount) || BigDecimal(0)
  end

  def last_bid_round
    last_bid.try(:round) || 0
  end

  def bidders_available_for_current_round(round_calculator = TradingItemBidRoundCalculator)
    current_round = round_calculator.new(self).calculate

    bidders_available(current_round.pred) - bidders.at_bid_round(current_round)
  end

  def finished_bid_stage?
     left_only_one_bidder && lowest_proposal_amount.present?
  end

  def bidders_by_lowest_proposal
    bidders.with_proposal_for_trading_item(id).sort { |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    }
  end

  def lowest_proposal_amount
    return unless bidder_with_lowest_proposal.present?

    bidder_with_lowest_proposal.lower_trading_item_bid_amount(self)
  end

  def first_bidder_available_for_current_round
    bidders_available_for_current_round.first
  end

  private

  def left_only_one_bidder
    bidders.with_no_proposal_for_trading_item(id).count == bidders.count - 1
  end

  def bidder_with_lowest_proposal
    bidders_by_lowest_proposal.first
  end

  def bidders_available(round)
    if round == 0
      bidders
    else
      bidders.with_proposal_for_trading_item_round(round)
    end
  end

  def last_bid
    trading_item_bids.last
  end

  def last_bid_with_proposal
    trading_item_bids.with_proposal.last
  end

  def require_at_least_one_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    errors.add(:minimum_reduction_percent, :presence_at_least_one)
    errors.add(:minimum_reduction_value, :presence_at_least_one)
  end
end
