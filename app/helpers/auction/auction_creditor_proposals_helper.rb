module Auction::AuctionCreditorProposalsHelper

  def init_item(object, item)
    aux = object
    object = object.auction_creditor_proposal_items.where(auction_item_id: item.id).last
    object = AuctionCreditorProposalItem.new(auction_creditor_proposal_id: aux.id, auction_item_id: item.id) if object.blank?

    object
  end

  def new_title
    base = I18n.t("#{controller_name}.new", :resource => singular, :cascade => true)

    base + " - Pregão #{resource.auction.licitation_number}/#{resource.auction.year}"
  end

  def edit_title
    "Proposta de Registro de Preço - Pregão #{resource.auction.licitation_number}/#{resource.auction.year}"
  end
end