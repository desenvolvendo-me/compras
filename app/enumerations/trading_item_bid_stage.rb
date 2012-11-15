class TradingItemBidStage < EnumerateIt::Base
  associate_values :proposals, :negociation, :round_of_bids
end
