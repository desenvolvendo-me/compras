# encoding: utf-8
BudgetAllocation.blueprint(:alocacao) do
  descriptor_id { 1 }
  code { 1 }
  budget_structure_id { 1 }
  function { Function.make!(:administracao) }
  subfunction { Subfunction.make!(:geral) }
  government_program { GovernmentProgram.make!(:habitacao) }
  government_action { GovernmentAction.make!(:governamental) }
  expense_nature { ExpenseNature.make!(:aposentadorias_reserva_reformas) }
  debt_type { DebtType::NOTHING }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  date { Date.current }
  budget_allocation_capabilities { [BudgetAllocationCapability.make!(:generic, amount: 500.0, budget_allocation: object)] }
  kind { BudgetAllocationKind::DIVIDE }
  reserve_funds { [ReserveFund.make!(:detran_2011, :budget_allocation => object)] }
  year { 2012 }
end

BudgetAllocation.blueprint(:alocacao_extra) do
  descriptor_id { 1 }
  code { 1 }
  budget_structure_id { 1 }
  function { Function.make!(:administracao) }
  subfunction { Subfunction.make!(:geral) }
  government_program { GovernmentProgram.make!(:habitacao) }
  government_action { GovernmentAction.make!(:governamental) }
  expense_nature { ExpenseNature.make!(:aposentadorias_reserva_reformas) }
  debt_type { DebtType::NOTHING }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  budget_allocation_capabilities { [BudgetAllocationCapability.make!(:generic, amount: 200.0, budget_allocation: object)] }
  date { Date.current }
  kind { BudgetAllocationKind::DIVIDE }
  year { 2011 }
end

BudgetAllocation.blueprint(:reparo_2011) do
  descriptor_id { 1 }
  code { 1 }
  budget_structure_id { 1 }
  function { Function.make!(:administracao) }
  subfunction { Subfunction.make!(:supervisor) }
  government_program { GovernmentProgram.make!(:educacao) }
  government_action { GovernmentAction.make!(:nacional) }
  expense_nature { ExpenseNature.make!(:aposentadorias_reserva_reformas) }
  debt_type { DebtType::NOTHING }
  refinancing { true }
  health { false }
  alienation_appeal { false }
  education { false }
  foresight { false }
  personal { false }
  date { Date.current }
  budget_allocation_capabilities { [BudgetAllocationCapability.make!(:generic, amount: 3000.0, budget_allocation: object)] }
  kind { BudgetAllocationKind::DIVIDE }
  year { 2011 }
end
