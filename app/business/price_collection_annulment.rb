class PriceCollectionAnnulment
  def initialize(price_collection)
    @price_collection = price_collection
  end

  def change!
    return unless annul.present?

    if @price_collection.annul!
      @price_collection.price_collection_proposals.each do |proposal|
        annul_proposal(proposal)
      end
    end
  end

  protected

  def annul
    @annul ||= @price_collection.annul
  end

  def annul_proposal(proposal)
    proposal_annul = proposal.build_annul(:employee_id => annul.employee_id, :date => annul.date, :description => annul.description)

    if proposal_annul.save
      proposal.annul!
    end
  end
end
