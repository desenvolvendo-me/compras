module Auction::AuctionsHelper

  def address(auction)
     "#{auction.street},   #{auction.neighborhood},  #{auction.city}"
  end

  def contact(auction)
    "#{auction.telephone} / #{auction.cell_phone}"
  end

  def proposal_link resource
    proposal = resource.creditor_proposals.where(user_id: current_user&.id).last
    if proposal
      route = edit_auction_auction_creditor_proposal_path(proposal.id)
    elsif current_user.present?
      route = new_auction_auction_creditor_proposal_path(auction_id: resource.id)
    else
      route = auction_providers_register_external_path
    end

    link_to "Proposta", route , class: 'btn btn-primary'
  end


  def disput_link resource
    route = auction_providers_register_external_path unless user_signed_in?
    route = "#" if user_signed_in?

    link_to "Entrar Disputa", route, class: 'button primary'
  end


end