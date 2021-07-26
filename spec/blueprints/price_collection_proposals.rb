PriceCollectionProposal.blueprint(:proposta_de_coleta_de_precos) do
  price_collection { PriceCollection.make!(:coleta_de_precos) }
  creditor { Creditor.make!(:wenderson_sa_with_user) }
  status { PriceCollectionStatus::ACTIVE }
end

PriceCollectionProposal.blueprint(:sobrinho_sa_proposta_without_user) do
  price_collection { PriceCollection.make!(:coleta_de_precos) }
  creditor { Creditor.make!(:sobrinho_sa) }
  status { PriceCollectionStatus::ACTIVE }
end

PriceCollectionProposal.blueprint(:sobrinho_sa_proposta) do
  price_collection { PriceCollection.make!(:coleta_de_precos) }
  creditor { Creditor.make!(:sobrinho_sa,
              accounts: [ CreditorBankAccount.make(:conta_2, number: '000101')],
              :user => User.make!(:geraldi)) }
  status { PriceCollectionStatus::ACTIVE }
end
