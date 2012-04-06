ReserveFund.blueprint(:detran_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:licitation) }
  date { Date.new(2012, 2, 21) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 10.5 }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_number { "001" }
  licitation_year { "2012" }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:nohup) }
  historic { "historic" }
end

ReserveFund.blueprint(:educacao_2011) do
  entity { Entity.make!(:secretaria_de_educacao) }
  year { 2011 }
  status { ReserveFundStatus::RESERVED }
  reserve_allocation_type { ReserveAllocationType.make!(:comum) }
  date { Date.new(2012, 2, 21) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 100.5 }
  process_number { "002" }
  process_year { "2013" }
  creditor { Creditor.make!(:nohup) }
  historic { "historic" }
end
