class PurchaseProcessCreditorProposalDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def unit_price
    number_with_precision super if super
  end

  def total_price
    number_with_precision super if super
  end

  def best_proposal
    proposal = component.class.best_proposal_for(component)

    number_with_precision(proposal.unit_price) if proposal
  end

  def unit_price_with_currency
    number_to_currency unit_price if unit_price
  end

  def total_price_with_currency
    number_to_currency total_price if total_price
  end

  def css_class(map_of_proposal = MapOfProposal)
    return "draw" if map_of_proposal.draw?(component)
    return "winner" if map_of_proposal.lowest_proposal?(component)

    "lost"
  end
end
