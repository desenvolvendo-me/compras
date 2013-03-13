# encoding: utf-8
ReserveFund.blueprint(:detran_2012) do
  descriptor { Descriptor.make!(:detran_2012) }
  status { ReserveFundStatus::RESERVED }
  date { Date.new(2012, 2, 22) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 10.5 }
  modality { Modality::COMPETITION }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end

ReserveFund.blueprint(:detran_2011) do
  descriptor { Descriptor.make!(:detran_2011) }
  status { ReserveFundStatus::RESERVED }
  date { Date.new(2012, 2, 21) }
  value { 10.5 }
  modality { Modality::COMPETITION }
  creditor { Creditor.make!(:wenderson_sa) }
  reason { 'Motivo para a reserva de dotação' }
end