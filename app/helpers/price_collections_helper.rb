# encoding: utf-8
module PriceCollectionsHelper
  def proposals_link
    return unless resource.persisted?

    link_to('Propostas', price_collection_price_collection_proposals_path(resource),
            :class => "button primary", 'data-disabled' => resource.decorator.proposals_not_allowed_message)
  end

  def count_link
    return unless resource.persisted?

    link_to('Relatório', price_collection_path(resource), :class => "button primary")
  end
end
