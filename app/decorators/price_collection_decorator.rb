# encoding: utf-8
class PriceCollectionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::UrlHelper

  def count_link
    return unless component.persisted?

    link_to('Relatório', routes.price_collection_path(component), :class => "button primary")
  end

  def proposals_link
    return unless component.persisted?

    link_to('Propostas', routes.price_collection_price_collection_proposals_path(component), :class => "button primary")
  end

  def winner_proposal_total_price
    number_with_precision super if super
  end

  def all_price_collection_classifications_groupped
    all_price_collection_classifications.group_by(&:creditor)
  end
end
