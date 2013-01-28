class TradingItem < Compras::Model
  attr_accessible :detailed_description, :minimum_reduction_percent,
                  :minimum_reduction_value, :trading_id,
                  :administrative_process_budget_allocation_item_id

  belongs_to :administrative_process_budget_allocation_item
  belongs_to :trading

  has_many :bidders, :through => :trading, :order => :id
  has_many :bids, :class_name => 'TradingItemBid', :dependent => :destroy, :order => :id

  has_one :closing, :dependent => :destroy, :class_name => 'TradingItemClosing'

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
  delegate :allow_closing?, :to => :trading, :prefix => true

  orderize :id

  default_scope { order(:id) }

  def self.not_closed
    joins { closing.outer }.
    where { closing.id.eq(nil) }
  end

  def lowest_proposal_value
    lowest_bid_with_proposal.try(:amount) || BigDecimal(0)
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
    bids.enabled.lowest_proposal_by_item_at_stage_of_proposals(self) || BigDecimal(0)
  end

  def selected_bidders_at_proposals
    bidders.selected_for_trading_item(self)
  end

  def value_limit_to_participate_in_bids
    (lowest_proposal_amount_at_stage_of_proposals * percentage_limit_to_participate_in_bids / 100) + lowest_proposal_amount_at_stage_of_proposals
  end

  def bidders_for_negotiation_by_lowest_proposal(with_all_proposals = false)
    bidders_selected_for_negotiation(with_all_proposals).sort do |a,b|
      a.lower_trading_item_bid_amount(self) <=> b.lower_trading_item_bid_amount(self)
    end
  end

  def allow_winner?
    started? && !closed? && (bidder_with_lowest_proposal.benefited || bidders_selected_for_negotiation.empty?)
  end

  def closed?
    closing.present?
  end

  def started?
    bids.any?
  end

  def valid_negotiation_proposals
    bids.negotiation.with_proposal
  end

  def last_bid
    bids.last
  end

  def proposals_for_round_of_bids?
    bids.at_stage_of_round_of_bids.any?
  end

  def with_proposal_for_round_of_proposals?
    bids.at_stage_of_proposals.with_proposal.any?
  end

  def valid_bidder_for_negotiation?
    bidders_selected_for_negotiation.any? && !valid_proposal_for_negotiation?
  end

  def allow_negotiation?
    bidders_selected_for_negotiation.any?
  end

  def rounds_uniq_at_stage_of_round_of_bids_ordered
    bids.at_stage_of_round_of_bids.reorder(:round).uniq.select(:round)
  end

  def bids_at_stage_of_round_of_bids_by_round_ordered_by_amount(round)
    bids.at_round(round).at_stage_of_round_of_bids.reorder('amount DESC')
  end

  def bids_at_stage_of_round_of_bids_ordered_by_amount
    bids.at_stage_of_proposals.reorder('amount DESC')
  end

  def bids_at_stage_of_negotiation_ordered_by_amount
    bids.at_stage_of_negotiation.reorder('amount DESC')
  end

  def bidder_with_lowest_proposal
    enabled_bidders_by_lowest_proposal.first
  end

  def activate_proposals!
    return false unless activate_proposals_allowed?

    update_column(:proposals_activated_at, DateTime.current)
  end

  def proposals_activated?
    proposals_activated_at.present?
  end

  def activate_proposals_allowed?
    bidders_enabled_not_selected.any? && !proposals_activated? && no_enabled_bidders_by_lowest_proposal_selected?
  end

  def bidders_enabled_not_selected
    bidders.enabled.not_selected_for_trading_item(self)
  end

  private

  def no_enabled_bidders_by_lowest_proposal_selected?
    enabled_bidders_by_lowest_proposal(:filter => :selected).empty?
  end

  def bidders_selected_for_negotiation(with_all_proposals = false)
    bidders_eligible_for_negotiation(with_all_proposals).select { |bidder| proposals_activated? || bidder.benefited }
  end

  def bidders_eligible_for_negotiation(with_all_proposals = false)
    if with_all_proposals
      bidders_with_proposal_eligible_for_negotiation
    else
      bidders_with_proposal_eligible_for_negotiation - bidders.with_negotiation_proposal_for(id)
    end
  end

  def bidders_with_proposal_eligible_for_negotiation
    bidders_with_proposals.enabled.eligible_for_negotiation_stage(bid_limit_for_negotiation_stage)
  end

  def bid_limit_for_negotiation_stage
    lowest_proposal_amount_with_valid_proposal * BigDecimal("1.05")
  end

  def lowest_proposal_amount_at_stage_of_proposals
    bids.with_proposal.at_stage_of_proposals.minimum(:amount)
  end

  def lowest_proposal_amount_with_valid_proposal
    if proposals_activated?
      bids.with_proposal.minimum(:amount)
    else
      bids.enabled.with_proposal.minimum(:amount)
    end
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
    if proposals_activated?
      bids.with_proposal.reorder { amount }.first
    else
      bids.enabled.with_proposal.reorder { amount }.first
    end
  end

  def valid_proposal_for_negotiation?
    bids.at_stage_of_negotiation.with_proposal.any?
  end

  def require_at_least_one_minimum_reduction
    return if minimum_reduction_percent > 0 || minimum_reduction_value > 0

    errors.add(:minimum_reduction_percent, :presence_at_least_one)
    errors.add(:minimum_reduction_value, :presence_at_least_one)
  end
end
