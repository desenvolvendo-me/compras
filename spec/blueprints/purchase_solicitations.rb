# encoding: utf-8
PurchaseSolicitation.blueprint(:reparo) do
  accounting_year { 2012 }
  request_date { Date.new(2012, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { PurchaseSolicitationServiceStatus::PENDING }
  liberation_date { Date.new(2012, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)]
  }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
end

PurchaseSolicitation.blueprint(:reparo_liberado) do
  accounting_year { 2012 }
  request_date { Date.new(2012, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { PurchaseSolicitationServiceStatus::LIBERATED }
  liberation_date { Date.new(2012, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)]
  }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  purchase_solicitation_liberations { [PurchaseSolicitationLiberation.make(:reparo)] }
end

PurchaseSolicitation.blueprint(:reparo_2013) do
  accounting_year { 2013 }
  request_date { Date.new(2013, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { PurchaseSolicitationServiceStatus::LIBERATED }
  liberation_date { Date.new(2013, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_2013)]
  }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
  purchase_solicitation_liberations { [PurchaseSolicitationLiberation.make!(:reparo, :purchase_solicitation => object)] }
end

PurchaseSolicitation.blueprint(:reparo_desenvolvimento) do
  accounting_year { 2012 }
  request_date { Date.new(2012, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:health) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { PurchaseSolicitationServiceStatus::PENDING }
  liberation_date { Date.new(2012, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)]
  }
  budget_structure { BudgetStructure.make!(:secretaria_de_desenvolvimento) }
end

PurchaseSolicitation.blueprint(:reparo_office) do
  accounting_year { 2012 }
  request_date { Date.new(2012, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { PurchaseSolicitationServiceStatus::PENDING }
  liberation_date { Date.new(2012, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)]
  }
  budget_structure { BudgetStructure.make!(:secretaria_de_educacao) }
end
