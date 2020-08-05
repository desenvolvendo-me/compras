module Auction::AuctionCreditorProposalsHelper

  def init_item(object, item)
    aux = object
    object = object.auction_creditor_proposal_items.where(auction_item_id: item.id).last
    object = AuctionCreditorProposalItem.new(auction_creditor_proposal_id: aux.id, auction_item_id: item.id) if object.blank?

    object
  end
end