module Auction::AuctionsHelper

  def address(auction)
     "#{auction.street},   #{auction.neighborhood},  #{auction.city}"
  end

  def contact(auction)
    "#{auction.telephone} / #{auction.cell_phone}"
  end

  def proposal_path resource
    return auction_providers_register_external_path unless current_user.present?

    return auctioneer_view_auction_proposals_path(auction_id: resource.id) if current_user.employee?

    edit_auction_proposal_path(resource.licitation_process_id, auction_id: resource)
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
