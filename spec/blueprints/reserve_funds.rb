ReserveFund.blueprint(:detran_2012) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 10.5 }
end

ReserveFund.blueprint(:educacao_2011) do
  year { 2011 }
  entity { Entity.make!(:secretaria_de_educacao) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 100.5 }
end
