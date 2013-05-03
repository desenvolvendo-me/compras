class MapOfProposal
  def initialize(proposal, proposal_repository = PurchaseProcessCreditorProposal)
    @proposal = proposal
    @proposal_repository = proposal_repository
  end

  def self.lowest_proposal?(proposal)
    self.new(proposal).lowest_proposal?
  end

  def self.draw?(proposal)
    self.new(proposal).draw?
  end

  def lowest_proposal?
    return false unless proposals_with_lowest_unit_price

    proposals_with_lowest_unit_price.member?(proposal) && proposals_with_lowest_unit_price.count == 1
  end

  def draw?
    if proposal.creditor.benefited
      value_lowest_proposal_with_margin >= proposal.unit_price
    else
      proposal_unit_price = proposal.unit_price
      other_proposals.where { unit_price.eq(proposal_unit_price) }.any?
    end
  end

  protected

  attr_accessor :proposal, :proposal_repository

  def other_proposals
    proposal_repository.where { |query|
      query.purchase_process_item_id.eq(proposal.item.id) &
      query.creditor_id.not_eq(proposal.creditor) }
  end

  def proposals
    proposal_repository.where { |query|
      query.purchase_process_item_id.eq(proposal.item.id) &
      query.unit_price.gt(0.0) }.order( :unit_price )
  end

  def lowest_proposal
    proposals.first
  end

  def proposals_with_lowest_unit_price
    proposal_repository.where { |query|
      query.purchase_process_item_id.eq(proposal.item.id) &
      query.unit_price.eq(lowest_proposal.unit_price) }
  end

  def value_lowest_proposal
    return unless lowest_proposal

    lowest_proposal.unit_price
  end

  def proposals_with_same_unit_price
    proposal_repository.where { item}
  end

  def value_lowest_proposal_with_margin
    return unless value_lowest_proposal

    value_lowest_proposal * 1.1
  end
end
