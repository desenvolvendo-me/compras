class PriceCollectionAnnulment
  def initialize(price_collection, proposal_annulment_class=PriceCollectionProposalAnnulment)
    @price_collection = price_collection
    @proposal_annulment_class = proposal_annulment_class
  end

  def change!
    return unless annul.present?

    if @price_collection.annul!
      @proposal_annulment_class.annul_proposals!(proposals, annul)
    end
  end

  protected

  def proposals
    @price_collection.price_collection_proposals
  end

  def annul
    @price_collection.annul
  end
end
