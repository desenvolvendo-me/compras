class TradingItem < Compras::Model
  attr_accessible :detailed_description, :minimum_reduction_percent,
                  :minimum_reduction_value, :order, :trading_id,
                  :administrative_process_budget_allocation_item_id

  auto_increment :order, :by => :trading_id

  belongs_to :trading
  belongs_to :administrative_process_budget_allocation_item

  has_many :trading_item_bids, :dependent => :destroy, :order => :id
  has_many :bidders, :through => :trading, :order => :id

  validates :minimum_reduction_percent, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_value?, :on => :update
  validates :minimum_reduction_value, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_percent?, :on => :update
  validates :minimum_reduction_percent, :numericality => { :less_than_or_equal_to => 100 },
            :on => :update

  validate :require_at_least_one_minimum_reduction, :on => :update

  delegate :material, :material_id, :reference_unit,
           :quantity, :unit_price, :to_s,
           :to => :administrative_process_budget_allocation_item,
           :allow_nil => true
  delegate :licitation_process_id, :percentage_limit_to_participate_in_bids,
           :to => :trading

  orderize :order

  def lowest_proposal_value
    lowest_bid_with_proposal.try(:amount) || BigDecimal(0)
  end

  def enabled_bidders_by_lowest_proposal
    bidders_with_proposals.enabled.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def bidders_by_lowest_proposal
    bidders_with_proposals.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def lowest_proposal_amount
    return unless bidder_with_lowest_proposal.present?

    bidder_with_lowest_proposal.lower_trading_item_bid_amount(self)
  end

  def selected_bidders_at_proposals
    bidders.with_proposal_for_proposal_stage_with_amount_lower_than_limit(value_limit_to_participate_in_bids)
  end

  def value_limit_to_participate_in_bids
    (lowest_proposal_amount_at_stage_of_proposals * percentage_limit_to_participate_in_bids / 100) + lowest_proposal_amount_at_stage_of_proposals
  end

  def bidders_for_negociation_by_lowest_proposal
    bidders_selected_for_negociation.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def allow_closing?
    bidder_with_lowest_proposal.benefited || bidders_selected_for_negociation.empty?
  end

  def close!(reference_date=Date.current)
    update_attribute(:closing_date, reference_date)
  end

  def closed?
    closing_date?
  end

  def valid_negotiation_proposals
    trading_item_bids.negotiation.with_proposal
  end

  def can_be_disabled?(bidder)
    (bidder_with_lowest_proposal == bidder) && !bidder.benefited
  end

  private

  def bidders_selected_for_negociation
    bidders_eligible_for_negociation.select { |bidder| bidder.benefited }
  end

  def bidders_eligible_for_negociation
    bidders_with_proposals.enabled.eligible_for_negociation_stage(bid_limit_for_negociation_stage) - bidders.with_negociation_proposal_for(id)
  end

  def bid_limit_for_negociation_stage
    lowest_proposal_amount_at_stage_of_round_of_bids * 1.05
  end

  def lowest_proposal_amount_at_stage_of_proposals
    trading_item_bids.with_proposal.at_stage_of_proposals.minimum(:amount)
  end

  def lowest_proposal_amount_at_stage_of_round_of_bids
    trading_item_bids.with_valid_proposal.at_stage_of_round_of_bids.minimum(:amount)
  end

  def bidders_with_proposals
    bidders.with_proposal_for_trading_item(id)
  end

  def bidder_with_lowest_proposal
    enabled_bidders_by_lowest_proposal.first
  end

  def lowest_bid_with_proposal
    trading_item_bids.with_valid_proposal.reorder { amount }.first
  end

  def require_at_least_one_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    errors.add(:minimum_reduction_percent, :presence_at_least_one)
    errors.add(:minimum_reduction_value, :presence_at_least_one)
  end
end
