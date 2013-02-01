# Returns the bidders selected for the stage of proposals
class TradingItemBidderSelector
  delegate :bidders, :bids, :percentage_limit_to_participate_in_bids,
           :to => :trading_item

  def initialize(trading_item)
    @trading_item = trading_item
  end

  def self.selected(*params)
    new(*params).bidders_selected
  end

  def self.not_selected(*params)
    new(*params).bidders_not_selected
  end

  def bidders_selected
    # When there is less than 3 bidders selected by the limit value assigned at
    # trading, than all the bidders with lower proposals should be selected
    # until have 3 bidders at least
    if bidders_selected_by_limit_value.count >= 3
      bidders_selected_by_limit_value
    else
      bidders_selected_at_playoffs
    end
  end

  def bidders_not_selected
    bidders.exclude_ids(bidders_selected.select(:id))
  end

  private

  attr_reader :trading_item

  def limit_value_to_be_selected
    (lowest_proposal_amount_at_stage_of_proposals * percentage_limit_to_participate_in_bids / BigDecimal(100)) + lowest_proposal_amount_at_stage_of_proposals
  end

  def lowest_proposal_amount_at_stage_of_proposals
    bids.with_proposal.at_stage_of_proposals.minimum(:amount)
  end

  def bidders_selected_by_limit_value
    bidders.under_limit_value(trading_item.id, limit_value_to_be_selected)
  end

  def bidders_selected_at_playoffs
    bidders.under_limit_value(trading_item.id, limit_value_for_playoffs)
  end

  # The higest proposal between the first three
  def limit_value_for_playoffs
    proposals_amount_ordered[0,3].last.amount
  end

  def proposals_amount_ordered
    bids.with_proposal.at_stage_of_proposals.reorder { amount }
  end
end
