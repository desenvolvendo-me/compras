class PriceCollectionProposalAnnulment
  def initialize(proposal)
    @proposal = proposal
  end

  def change!
    @proposal.annul! if @proposal.annul.present?
  end
end
