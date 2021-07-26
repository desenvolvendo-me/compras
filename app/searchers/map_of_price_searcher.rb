class MapOfPriceSearcher
  include Quaestio
  repository PriceCollectionProposalItem

  def price_collection(id)
    joins { price_collection_proposal }.
    where { price_collection_proposal.price_collection_id.eq id }.
    order { unit_price }
  end
end
