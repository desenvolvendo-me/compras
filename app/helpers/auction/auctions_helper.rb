module Auction::AuctionsHelper

  def address(auction)
     "#{auction.street},   #{auction.neighborhood},  #{auction.city}"
  end

  def contact(auction)
    "#{auction.telephone} / #{auction.cell_phone}"
  end

  def proposal_path resource
    if current_user.try(:authenticable_type) == 'Employee'
      return auctioneer_view_auction_auction_creditor_proposals_path(auction_id: resource.id)
    end

    proposal = resource.creditor_proposals.where(creditor_id: current_user&.authenticable&.id).last
    if proposal
      route = edit_auction_auction_creditor_proposal_path(proposal.id)
    elsif current_user.present?
      route = new_auction_auction_creditor_proposal_path(auction_id: resource.id)
    else
      route = auction_providers_register_external_path
    end

    route
  end


  def disput_link resource
    route = auction_providers_register_external_path unless user_signed_in?
    route = "#" if user_signed_in?

    link_to "Entrar Disputa", route, class: 'button primary'
  end

  def link_to_appeals(&block)
   if resource.appeal.present?
     link_to edit_auction_appeal_path(resource.appeal), class:'card-link' do
       content = capture(&block)
       content.html_safe
     end
   else
     link_to new_auction_appeal_path(auction_id: resource.id), class:'card-link', 'data-confirm': 'Deseja cadastrar uma Intenção de Recurso?' do
       content = capture(&block)
       content.html_safe
     end
   end
  end

  def link_to_suspension(&block)
    if resource.suspension.present?
      link_to edit_auction_auction_suspension_path(resource.id, resource.suspension), class:'card-link' do
        content = capture(&block)
        content.html_safe
      end
    else
      link_to new_auction_auction_suspension_path(resource.id), class:'card-link' do
        content = capture(&block)
        content.html_safe
      end
    end
  end
end
