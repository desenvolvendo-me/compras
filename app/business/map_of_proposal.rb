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
    if proposal == lowest_proposal
      proposals_with_lowest_unit_price.count > 1
    elsif proposal.creditor_benefited && !lowest_proposal.creditor_benefited
      value_lowest_proposal_with_margin >= proposal.unit_price
    else
      value_lowest_proposal == proposal.unit_price && lowest_proposal != proposal
    end
  end

  protected

  attr_accessor :proposal, :proposal_repository

  def proposals
    proposals_by_item_or_lot.unit_price_greater_than(0.0).order(:unit_price)
  end

  def lowest_proposal
    proposals.first
  end

  def proposals_with_lowest_unit_price
    proposals_by_item_or_lot.unit_price_equal(lowest_proposal.unit_price)
  end

  def proposals_by_item_or_lot
    if proposal.licitation_process.judgment_form_lot?
      proposal_repository.licitation_process_id(proposal.licitation_process.id)
        .by_lot(proposal.lot)
    else
      proposal_repository.by_item_id(proposal.item.id)
    end
  end

  def value_lowest_proposal
    return unless lowest_proposal

    lowest_proposal.unit_price
  end

  def value_lowest_proposal_with_margin
    return unless value_lowest_proposal

    value_lowest_proposal * 1.1
  end
end
