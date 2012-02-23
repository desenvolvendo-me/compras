ReserveFund.blueprint(:detran_2012) do
  year { 2012 }
  entity { Entity.make!(:detran) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 10.5 }
end
