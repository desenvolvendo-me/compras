class TradingItemBidStage < EnumerateIt::Base
  associate_values :proposals, :negotiation, :round_of_bids

  def self.current_stage(trading_item, stage_calculator = TradingItemBidStageCalculator)
    if stage_calculator.new(trading_item).stage_of_proposals?
      PROPOSALS
    elsif stage_calculator.new(trading_item).stage_of_negotiation?
      NEGOTIATION
    else
      ROUND_OF_BIDS
    end
  end
end
