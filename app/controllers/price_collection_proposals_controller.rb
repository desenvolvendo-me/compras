class PriceCollectionProposalsController < CrudController
  protected

  def begin_of_association_chain
    if current_user.provider?
      current_user.authenticable
    elsif params.has_key?(:price_collection_id)
      @parent = PriceCollection.find(params.fetch(:price_collection_id))
    end
  end
end
