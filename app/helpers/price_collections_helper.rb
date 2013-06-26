# encoding: utf-8
module PriceCollectionsHelper
  def count_link
    return unless resource.persisted?

    link_to('Relatório', price_collection_path(resource), :class => "button primary")
  end
end
