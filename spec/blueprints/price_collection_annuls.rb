PriceCollectionAnnul.blueprint(:coleta_anulada) do
  price_collection { PriceCollection.make!(:coleta_de_precos_anulada) }
  annul_type { PriceCollectionAnnulType::ANNULMENT }
  employee { Employee.make!(:sobrinho) }
  date { Date.current }
end
