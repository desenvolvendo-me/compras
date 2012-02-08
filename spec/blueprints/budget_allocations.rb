# encoding: utf-8
BudgetAllocation.blueprint(:alocacao) do
  name { "Alocação" }
  amount { "500,00" }
end

BudgetAllocation.blueprint(:alocacao_extra) do
  name { "Alocação extra" }
  amount { "200,00" }
end

BudgetAllocation.blueprint(:conserto) do
  name { "Conserto" }
  amount { "300,00" }
end
