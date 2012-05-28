class PriceCollectionDecorator < Decorator
  def count_link
    return unless component.persisted?

    helpers.link_to('Apurar', routes.price_collection_path(component), :class => "button primary")
  end
end
