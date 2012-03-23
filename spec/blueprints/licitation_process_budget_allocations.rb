LicitationProcessBudgetAllocation.blueprint(:alocacao) do
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  estimated_value { 50.0 }
  pledge_type { PledgeType::GLOBAL }
end
