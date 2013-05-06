#encoding: utf-8
class PurchaseProcessCreditorProposalDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def creditors_title
    "Proposta Comercial Processo #{licitation_process.to_s}"
  end

  def unit_price
    number_with_precision super if super
  end

  def total_price
    number_with_precision super if super
  end

  def subtitle
    "Fornecedor #{creditor} - Processo #{licitation_process.to_s}"
  end

  def unit_price_with_currency
    number_to_currency unit_price if unit_price
  end

  def total_price_with_currency
    number_to_currency total_price if total_price
  end

  def css_class(proposal, map_of_proposal = MapOfProposal)
    return "draw" if map_of_proposal.draw?(proposal)
    return "winner" if map_of_proposal.lowest_proposal?(proposal)

    "lost"
  end
end
