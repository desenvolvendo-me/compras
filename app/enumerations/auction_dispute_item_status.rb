class AuctionDisputeItemStatus < EnumerateIt::Base
  associate_values :closed, :open, :suspended, :finished
end
