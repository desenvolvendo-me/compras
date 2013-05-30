class PurchaseProcessCreditorProposalRanking
  attr_accessor :creditor_proposal, :all_proposals

  def initialize(creditor_proposal, repository = PurchaseProcessCreditorProposal)
    self.creditor_proposal = creditor_proposal
    self.all_proposals = repository.find_brothers(creditor_proposal)
  end

  def self.rank!(creditor_proposal)
    self.new(creditor_proposal).set_ranking
  end

  def set_ranking
    ranking = 1

    each_ordered_proposals do |proposals|
      rank_proposals proposals, ranking
      ranking += proposals.size
    end
  end

  private

  def each_ordered_proposals
    all_proposals.group_by(&:unit_price).each_pair do |price, proposals|
      yield proposals
    end
  end

  def rank_proposals(proposals, ranking)
    if proposals.size == 1
      proposals.first.apply_ranking! ranking
    else
      draw_proposals proposals
    end
  end

  def draw_proposals(proposals)
    proposals.each(&:reset_ranking!)
  end
end
