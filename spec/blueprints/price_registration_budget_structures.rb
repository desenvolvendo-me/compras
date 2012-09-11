PriceRegistrationBudgetStructure.blueprint(:secretaria_de_educacao) do
  budget_structure { BudgetStructure.make(:secretaria_de_educacao) }
  quantity_requested { "100,00" }
end

PriceRegistrationBudgetStructure.blueprint(:secretaria_de_desenvolvimento) do
  budget_structure { BudgetStructure.make(:secretaria_de_desenvolvimento) }
  quantity_requested { "200,00" }
end
