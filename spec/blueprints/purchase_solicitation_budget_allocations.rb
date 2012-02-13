# encoding: utf-8
PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  economic_classification_of_expenditure { EconomicClassificationOfExpenditure.make!(:compra_de_material) }
  estimated_value { "20" }
  blocked { false }
end

PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_secundaria) do
  budget_allocation { BudgetAllocation.make!(:alocacao_extra) }
  economic_classification_of_expenditure { EconomicClassificationOfExpenditure.make!(:compra_de_material) }
  estimated_value { "30" }
  blocked { false }
end
