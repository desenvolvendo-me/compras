class PriceCollectionDecorator < Decorator
  def count_link
    return unless component.persisted?

    helpers.link_to('Apurar', routes.price_collection_path(component), :class => "button primary")
  end

  def proposals_link
    return unless component.persisted?

    helpers.link_to('Propostas', routes.price_collection_price_collection_proposals_path(component), :class => "button primary")
  end

  def winner_proposal_total_price
    helpers.number_with_precision super if super
  end

  def all_price_collection_classifications_groupped
    all_price_collection_classifications.group_by(&:creditor)
  end
end
