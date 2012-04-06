# encoding: utf-8
PurchaseSolicitation.blueprint(:reparo) do
  accounting_year { "2012" }
  request_date { Date.new(2012, 1, 31) }
  responsible { Employee.make!(:sobrinho) }
  justification { "Reparo nas instalações" }
  delivery_location { DeliveryLocation.make!(:education) }
  kind { "goods" }
  general_observations { "Reparos nas instalações superiores" }
  service_status { "pending" }
  liberation_date { Date.new(2012, 1, 31) }
  liberator { Employee.make!(:sobrinho) }
  service_observations { "Pronto" }
  no_service_justification { "n/a" }
  purchase_solicitation_budget_allocations {
    [PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)]
  }
end
