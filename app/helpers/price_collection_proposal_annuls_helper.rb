# encoding: utf-8
module PriceCollectionProposalAnnulsHelper
  def new_title
    "Anular Proposta do Fornecedor #{resource.creditor} para a Coleta de Preço #{resource.price_collection}"
  end

  def edit_title
    "Anulação da Proposta de #{resource.creditor} para a Coleta de Preço #{resource.price_collection}"
  end
end
