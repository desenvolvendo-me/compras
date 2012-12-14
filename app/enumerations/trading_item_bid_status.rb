class TradingItemBidStatus < EnumerateIt::Base
  associate_values :disqualified, :without_proposal, :with_proposal, :declined
end
