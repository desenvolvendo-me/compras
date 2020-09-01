class PriceCollectionProposalAnnulsController < ResourceAnnulsController
  def create
    create!{ edit_price_collection_path(resource.annullable.price_collection_id) }
  end

  protected

  def annul(object)
    PriceCollectionProposalAnnulment.new(object.annullable).change!
  end
end
