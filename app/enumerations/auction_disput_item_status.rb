class AuctionDisputItemStatus < EnumerateIt::Base
  associate_values :closed, :open, :suspended, :finished
end
