class TradingBidStatusChooser
  def initialize(bid)
    @bid = bid
  end

  def choose
    if @bid.amount > BigDecimal('0')
      TradingItemBidStatus::WITH_PROPOSAL
    else
      TradingItemBidStatus::DECLINED
    end
  end
end
