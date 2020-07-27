module Auction::AuctionsHelper

  def address(auction)
     "#{auction.street},   #{auction.neighborhood},  #{auction.city}"
  end

  def contact(auction)
    "#{auction.telephone} / #{auction.cell_phone}"
  end


end