# encoding: utf-8
DirectPurchase.blueprint(:compra) do
  ModalityLimit.make!(:modalidade_de_compra)
  direct_purchase { 1 }
  year { 2012 }
  date { Date.new(2012, 3, 2) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::MATERIAL_OR_SERVICE }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:wenderson_sa) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Observacoes" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 600.00 }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra)] }
end

DirectPurchase.blueprint(:compra_nao_autorizada) do
  ModalityLimit.make!(:modalidade_de_compra)
  direct_purchase { 2 }
  year { 2012 }
  date { Date.new(2012, 12, 1) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::MATERIAL_OR_SERVICE }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:wenderson_sa) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Compra de 2012 ainda não autorizada" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 600.00 }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra_extra)] }
end

DirectPurchase.blueprint(:compra_2011) do
  ModalityLimit.make!(:modalidade_de_compra)
  year { 2011 }
  direct_purchase { 3 }
  date { Date.new(2011, 11, 11) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::ENGINEERING_WORKS }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:wenderson_sa) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Compra feita em 2011 e não authorizada" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 600.00 }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra_engenharia)] }
end

DirectPurchase.blueprint(:compra_2011_dez) do
  ModalityLimit.make!(:modalidade_de_compra)
  year { 2011 }
  direct_purchase { 3 }
  date { Date.new(2011, 12, 20) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::ENGINEERING_WORKS }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:wenderson_sa) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Compra feita em 2011 e não authorizada" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 600.00 }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra_engenharia)] }
end

DirectPurchase.blueprint(:company_purchase) do
  ModalityLimit.make!(:modalidade_de_compra)
  year { 2011 }
  direct_purchase { 3 }
  date { Date.new(2011, 12, 20) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::ENGINEERING_WORKS }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:nohup) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Compra feita em 2011 e não autorizada" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 600.00 }
  direct_purchase_budget_allocations { [DirectPurchaseBudgetAllocation.make!(:alocacao_compra_engenharia)] }
end

DirectPurchase.blueprint(:compra_perto_do_limite) do
  ModalityLimit.make!(:modalidade_de_compra)
  direct_purchase { 1 }
  year { 2012 }
  date { Date.new(2012, 3, 2) }
  legal_reference { LegalReference.make!(:referencia) }
  modality { DirectPurchaseModality::MATERIAL_OR_SERVICE }
  pledge_type { DirectPurchasePledgeType::GLOBAL }
  creditor { Creditor.make!(:wenderson_sa) }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  licitation_object { LicitationObject.make!(:ponte) }
  delivery_location { DeliveryLocation.make!(:education) }
  employee { Employee.make!(:sobrinho) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  price_collection { 9.99 }
  price_registration { PriceRegistration.make!(:registro_de_precos) }
  observation { "Observacoes" }
  delivery_term { 1 }
  delivery_term_period { PeriodUnit::YEAR }
  total_allocations_items_value { 90000 }
  direct_purchase_budget_allocations { [
    DirectPurchaseBudgetAllocation.make!(:valores_proximo_ao_limite)
  ] }
end
