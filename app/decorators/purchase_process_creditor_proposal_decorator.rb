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
end
