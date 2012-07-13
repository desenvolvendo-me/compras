class PriceCollectionProposalAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
    PriceCollectionProposalAnnulment.new(object.annullable).change!
  end
end
