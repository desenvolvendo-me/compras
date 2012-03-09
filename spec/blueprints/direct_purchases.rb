# encoding: utf-8
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

DirectPurchase.blueprint(:compra_nao_autorizada) do
  year { 2012 }
  date { "2012-12-01" }
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
  observation { "Compra de 2012 ainda não autorizada" }
  period { Period.make!(:um_ano) }
  status { DirectPurchaseStatus::UNAUTHORIZED }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra)] }
end

DirectPurchase.blueprint(:compra_2011) do
  year { 2011 }
  date { "2011-11-11" }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::ENGINEERING_WORKS }
  provider { Provider.make!(:wenderson_sa) }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { "9,99" }
  price_registration { "8,88" }
  observation { "Compra feita em 2011 e não authorizada" }
  period { Period.make!(:um_ano) }
  status { DirectPurchaseStatus::UNAUTHORIZED }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra)] }
end
