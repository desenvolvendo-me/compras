DirectPurchase.blueprint(:compra) do
  year { 2012 }
  date { "2012-03-02" }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::MATERIAL_OR_SERVICE }
  provider { Provider.make!(:wenderson_sa) }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { "9,99" }
  price_registration { "8,88" }
  observation { "Observacoes" }
  period { Period.make!(:um_ano) }
  status { DirectPurchaseStatus::AUTHORIZED }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra)] }
end
