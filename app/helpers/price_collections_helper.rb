#encoding: utf-8
module PriceCollectionsHelper
  def price_collection_winner(classification)
    classification == 1 ? 'Sim' : 'Não'
  end
end
