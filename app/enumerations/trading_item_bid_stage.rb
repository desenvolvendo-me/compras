class TradingItemBidStage < EnumerateIt::Base
  associate_values :proposals, :negotiation, :round_of_bids
end
