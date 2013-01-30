class TradingItemBidders
  def initialize(trading_item, bidders, options = {})
    @trading_item = trading_item
    @bidders = bidders
    @bidder_repository = options.fetch(:bidder_repository) { Bidder }
  end

  def selected_for_trading_item
    bidders.selected_for_trading_item(trading_item)
  end

  def selected_for_trading_item_size
    selected_for_trading_item.size
  end

  def with_proposal_for_round(round)
    bidders.with_proposal_for_trading_item_round(round)
  end

  def at_bid_round(round)
    bidders.at_bid_round(round, trading_item.id)
  end

  def for_stage_of_round_of_bids(round_of_bids = TradingItemBidStage::ROUND_OF_BIDS)
    bidders.at_trading_item_stage(trading_item, round_of_bids)
  end

  def bidders_ordered_by_amount
    sql = %Q(
      SELECT "bidders".*
      FROM "compras_bidders" AS "bidders"
      INNER JOIN (
        SELECT "bids"."bidder_id", MIN("bids"."amount") AS min_id
        FROM "compras_trading_item_bids" AS "bids"
        WHERE
          "bids"."trading_item_id" = ? AND "bids"."bidder_id" IN (?)
        GROUP BY "bids"."bidder_id") AS "grouped" ON "grouped"."bidder_id" = "bidders"."id"
      ORDER BY "grouped"."min_id", "bidders"."id"
    ), trading_item.id, bidders.map(&:id)

    bidder_repository.find_by_sql(sql)
  end

  private

  attr_reader :trading_item, :bidders, :bidder_repository
end
