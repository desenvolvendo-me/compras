class PriceCollectionProposalAnnulment
  def initialize(proposal)
    @proposal = proposal
  end

  def change!
    return unless @proposal.annul.present?

    @proposal.annul!
  end

  def create_annul!(annul)
    proposal_annul = @proposal.build_annul(:employee_id => annul.employee_id, :date => annul.date, :description => annul.description)

    proposal_annul.save
  end

  def self.annul_proposals!(proposals, annul)
    proposals.each do |proposal|
      annul_proposal!(proposal, annul)
    end
  end

  protected

  def self.annul_proposal!(proposal, annul)
    instance = PriceCollectionProposalAnnulment.new(proposal)

    if instance.create_annul!(annul)
      instance.change!
    end
  end
end
