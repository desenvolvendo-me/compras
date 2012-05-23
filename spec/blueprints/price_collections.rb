PriceCollection.blueprint(:coleta_de_precos) do
  collection_number { 1 }
  year { 2012 }
  date { Date.current }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  period { Period.make!(:um_ano) }
  object_description { "object" }
  observations { "observations" }
  proposal_validity { Period.make!(:um_ano) }
  expiration { Date.tomorrow }
  status { Status::ACTIVE }
  price_collection_lots { [PriceCollectionLot.make!(:lote_da_coleta)] }
end
