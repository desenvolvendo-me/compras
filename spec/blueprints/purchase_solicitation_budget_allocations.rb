# encoding: utf-8
PurchaseSolicitationBudgetAllocation.blueprint(:alocacao_primaria) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  expense_element { ExpenseElement.make!(:compra_de_material) }
  estimated_value { "20" }
  blocked { false }
  items { [PurchaseSolicitationBudgetAllocationItem.make!(:item)] }
end
