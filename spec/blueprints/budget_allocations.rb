# encoding: utf-8
BudgetAllocation.blueprint(:alocacao) do
  description { "Alocação" }
  amount { "500,00" }
end

BudgetAllocation.blueprint(:alocacao_extra) do
  description { "Alocação extra" }
  amount { "200,00" }
end

BudgetAllocation.blueprint(:conserto) do
  description { "Conserto" }
  amount { "300,00" }
end
