module PriceCollectionsHelper
  def count_link
    return unless resource.persisted?

    link_to('Relatório', price_collection_path(resource), :class => "button primary")
  end

  def generate_proposal_items(price_collection)
    proposal = PriceCollectionProposal.new
    proposal.price_collection_id = price_collection.id
    price_collection_items = price_collection.items.reject(&:new_record?)

    price_collection_items.each do |item|
      proposal.items.build(:price_collection_item_id => item.id)
    end

    proposal
  end
end
