PriceCollectionProposal.blueprint(:proposta_de_coleta_de_precos) do
  price_collection { PriceCollection.make!(:coleta_de_precos) }
  provider { Provider.make!(:wenderson_sa_with_user) }
end