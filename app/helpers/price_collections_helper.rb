#encoding: utf-8
module PriceCollectionsHelper
  def price_collection_annul_link
    return if resource.new_record?

    if resource.active?
      link_to 'Anular', new_price_collection_annul_path(:price_collection_id => resource.id), :class => 'button primary'
    elsif resource.annulled?
      link_to 'Anulação', edit_price_collection_annul_path(resource.annul), :class => 'button primary'
    end
  end
end
