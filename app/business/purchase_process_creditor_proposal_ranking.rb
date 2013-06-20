class PurchaseProcessCreditorProposalRanking
  def initialize(creditor_proposal, repository = PurchaseProcessCreditorProposal)
    @creditor_proposal = creditor_proposal
    @repository        = repository
  end

  def self.rank!(creditor_proposal)
    self.new(creditor_proposal).set_ranking
  end

  def set_ranking
    ranking = 1

    reset_proposals

    each_ordered_proposals do |proposals|
      rank_proposals proposals, ranking
      ranking += proposals.size
    end
  end

  private

  attr_reader :creditor_proposal, :repository

  def each_ordered_proposals
    all_proposals.group_by(&:benefited_unit_price).each_pair do |price, proposals|
      yield proposals
    end
  end

  def rank_proposals(proposals, ranking)
    if proposals.size == 1
      proposals.first.apply_ranking! ranking
    else
      tie_proposals proposals
    end
  end

  def tie_proposals(proposals)
    proposals.each(&:tie_ranking!)
  end

  def reset_proposals
    repository.find_brothers(creditor_proposal).each(&:reset_ranking!)
  end

  def all_proposals
    if creditor_proposal.licitation_process_trading?
      repository.find_brothers_for_ranking(creditor_proposal)
    else
      repository.find_brothers_for_ranking_with_bidder_enabled(creditor_proposal)
    end
  end
end
