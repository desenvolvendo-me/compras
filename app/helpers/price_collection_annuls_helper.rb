# encoding: utf-8
module PriceCollectionAnnulsHelper
  def new_title
   "Anular Coleta de Preço #{resource.price_collection}"
  end

  def edit_title
    "Anulação da Coleta de Preço #{resource.price_collection}"
  end
end
