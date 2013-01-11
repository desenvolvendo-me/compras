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

  default_scope { order(:id) }

  def lowest_proposal_value
    lowest_bid_with_proposal.try(:amount) || BigDecimal(0)
  end

  def lowest_proposal_bidder
    lowest_bid_with_proposal.try(:bidder) || ''
  end

  def enabled_bidders_by_lowest_proposal(options = {})
    initial_scope = bidders_with_proposals.enabled

    if :selected == options[:filter]
      initial_scope = initial_scope.selected_for_trading_item(self)
    elsif :not_selected == options[:filter]
      initial_scope = initial_scope.not_selected_for_trading_item(self)
    end

    initial_scope.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def disabled_bidders_by_lowest_proposal
    bidders_with_proposals.disabled.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def bidders_by_lowest_proposal
    bidders_with_proposals.sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def bidders_by_lowest_proposal_at_stage_of_round_of_bids
    bidders_with_proposals_at_stage_of_round_of_bids.sort do |a,b|
      a.lower_trading_item_bid_amount_at_stage_of_round_of_bids(self) <=> b.lower_trading_item_bid_amount_at_stage_of_round_of_bids(self)
    end
  end

  def bidders_benefited_by_lowest_proposal_at_stage_of_round_of_bids
    bidders_benefited_with_proposals_at_stage_of_round_of_bids.sort do |a,b|
      a.lower_trading_item_bid_amount_at_stage_of_round_of_bids(self) <=> b.lower_trading_item_bid_amount_at_stage_of_round_of_bids(self)
    end
  end

  def bidders_by_lowest_proposal_at_stage_of_negotiation
    bidders_with_proposals_at_stage_of_negotiaton.sort do |a,b|
      a.lower_trading_item_bid_amount_at_stage_of_negotiation(self) <=> b.lower_trading_item_bid_amount_at_stage_of_negotiation(self)
    end
  end

  def lowest_proposal_amount
    return unless bidder_with_lowest_proposal.present?

    bidder_with_lowest_proposal.lower_trading_item_bid_amount(self)
  end

  def lowest_proposal_at_stage_of_proposals_amount
    trading_item_bids.enabled.lowest_proposal_by_item_at_stage_of_proposals(self) || BigDecimal(0)
  end

  def selected_bidders_at_proposals
    bidders.selected_for_trading_item(self)
  end

  def value_limit_to_participate_in_bids
    (lowest_proposal_amount_at_stage_of_proposals * percentage_limit_to_participate_in_bids / 100) + lowest_proposal_amount_at_stage_of_proposals
  end

  def bidders_for_negociation_by_lowest_proposal(with_all_proposals = false)
    bidders_selected_for_negociation(with_all_proposals).sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def allow_closing?
    (bidder_with_lowest_proposal.benefited || bidders_selected_for_negociation.empty?) && !closed?
  end

  def close!(reference_date=Date.current)
    update_attribute(:closing_date, reference_date)
  end

  def closed?
    closing_date?
  end

  def started?
    trading_item_bids.any?
  end

  def valid_negotiation_proposals
    trading_item_bids.negotiation.with_proposal
  end

  def last_bid
    trading_item_bids.last
  end

  def proposals_for_round_of_bids?
    trading_item_bids.at_stage_of_round_of_bids.any?
  end

  def with_proposal_for_round_of_proposals?
    trading_item_bids.at_stage_of_proposals.with_proposal.any?
  end

  def valid_bidder_for_negotiation?
    bidders_selected_for_negociation.any? && !valid_proposal_for_negotiation?
  end

  def rounds_uniq_at_stage_of_round_of_bids_ordered
    trading_item_bids.at_stage_of_round_of_bids.reorder(:round).uniq.select(:round)
  end

  def bids_at_stage_of_round_of_bids_by_round_ordered_by_amount(round)
    trading_item_bids.at_round(round).at_stage_of_round_of_bids.reorder('amount DESC')
  end

  def bids_at_stage_of_round_of_bids_ordered_by_amount
    trading_item_bids.at_stage_of_proposals.reorder('amount DESC')
  end

  def bids_at_stage_of_negotiation_ordered_by_amount
    trading_item_bids.at_stage_of_negotiation.reorder('amount DESC')
  end

  def bidder_with_lowest_proposal
    enabled_bidders_by_lowest_proposal.first
  end

  private

  def bidders_selected_for_negociation(with_all_proposals = false)
    bidders_eligible_for_negociation(with_all_proposals).select { |bidder| bidder.benefited }
  end

  def bidders_eligible_for_negociation(with_all_proposals = false)
    if with_all_proposals
      bidders_with_proposal_eligible_for_negotiation
    else
      bidders_with_proposal_eligible_for_negotiation - bidders.with_negociation_proposal_for(id)
    end
  end

  def bidders_with_proposal_eligible_for_negotiation
    bidders_with_proposals.enabled.eligible_for_negociation_stage(bid_limit_for_negociation_stage)
  end

  def bid_limit_for_negociation_stage
    lowest_proposal_amount_with_valid_proposal * BigDecimal("1.05")
  end

  def lowest_proposal_amount_at_stage_of_proposals
    trading_item_bids.with_proposal.at_stage_of_proposals.minimum(:amount)
  end

  def lowest_proposal_amount_with_valid_proposal
    trading_item_bids.with_valid_proposal.minimum(:amount)
  end

  def bidders_with_proposals
    bidders.with_proposal_for_trading_item(id)
  end

  def bidders_with_proposals_at_stage_of_round_of_bids
    bidders.with_proposal_for_trading_item_at_stage_of_round_of_bids(id)
  end

  def bidders_benefited_with_proposals_at_stage_of_round_of_bids
    bidders.benefited.with_proposal_for_trading_item_at_stage_of_round_of_bids(id)
  end

  def bidders_with_proposals_at_stage_of_negotiaton
    bidders.with_proposal_for_trading_item_at_stage_of_negotiation(id)
  end

  def lowest_bid_with_proposal
    trading_item_bids.with_valid_proposal.reorder { amount }.first
  end

  def valid_proposal_for_negotiation?
    trading_item_bids.at_stage_of_negotiation.with_proposal.any?
  end

  def require_at_least_one_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    errors.add(:minimum_reduction_percent, :presence_at_least_one)
    errors.add(:minimum_reduction_value, :presence_at_least_one)
  end
end
