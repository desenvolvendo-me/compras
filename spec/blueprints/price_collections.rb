PriceCollection.blueprint(:coleta_de_precos) do
  type_of_calculation { PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { 1 }
  proposal_validity_unit { PeriodUnit::YEAR }
  expiration { Date.tomorrow }
  status { PriceCollectionStatus::ACTIVE }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta)] }
  price_collection_proposals { [PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => object)] }
end

PriceCollection.blueprint(:coleta_de_precos_anulada) do
  type_of_calculation { PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { 1 }
  proposal_validity_unit { PeriodUnit::YEAR }
  expiration { Date.tomorrow }
  status { PriceCollectionStatus::ANNULLED }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta)] }
  price_collection_proposals { [PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => object, :status => PriceCollectionStatus::ANNULLED)] }
end

PriceCollection.blueprint(:coleta_de_precos_com_2_propostas) do
  type_of_calculation { PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { 1 }
  proposal_validity_unit { PeriodUnit::YEAR }
  expiration { Date.tomorrow }
  status { PriceCollectionStatus::ACTIVE }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta)] }
  price_collection_proposals { [PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, :price_collection => object), PriceCollectionProposal.make!(:sobrinho_sa_proposta_without_user, :price_collection => object)] }
end

PriceCollection.blueprint(:coleta_de_precos_com_2_lotes) do
  type_of_calculation { PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { 1 }
  proposal_validity_unit { PeriodUnit::YEAR }
  expiration { Date.tomorrow }
  status { PriceCollectionStatus::ACTIVE }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta, :price_collection => object),
                           PriceCollectionLot.make!(:arames, :price_collection => object)] }
end

PriceCollection.blueprint(:coleta_de_precos_com_2_itens_no_mesmo_lote) do
  type_of_calculation { PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { 1 }
  proposal_validity_unit { PeriodUnit::YEAR }
  expiration { Date.tomorrow }
  status { PriceCollectionStatus::ACTIVE }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta_com_2_itens, :price_collection => object)] }
end
