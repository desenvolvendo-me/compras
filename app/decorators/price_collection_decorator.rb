class PriceCollectionDecorator < Decorator
  def count_link
    return unless component.persisted?

    helpers.link_to('Apurar', routes.price_collection_path(component), :class => "button primary")
  end

  def winner_proposal_total_price
    helpers.number_with_precision super if super
  end
end
