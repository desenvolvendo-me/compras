# encoding: utf-8
AdministrativeProcess.blueprint(:compra_de_cadeiras) do
  process { 1 }
  year { 2012 }
  date { Date.new(2012, 3, 7) }
  protocol { '00099/2012' }
  budget_unit { BudgetUnit.make!(:secretaria_de_educacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao)] }
end

AdministrativeProcess.blueprint(:compra_de_computadores) do
  process { 2 }
  year { 2013 }
  date { Date.new(2012, 3, 7) }
  protocol { '00099/2012' }
  budget_unit { BudgetUnit.make!(:secretaria_de_educacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de computadores' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
  item { 'Item 2' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao)] }
end

AdministrativeProcess.blueprint(:compra_sem_convite) do
  process { 2 }
  year { 2014 }
  date { Date.new(2012, 3, 7) }
  protocol { '00099/2012' }
  budget_unit { BudgetUnit.make!(:secretaria_de_educacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::PRESENCE_TRADING }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de computadores' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
  item { 'Item 2' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
end

AdministrativeProcess.blueprint(:compra_com_itens) do
  process { 1 }
  year { 2012 }
  date { Date.new(2012, 3, 7) }
  protocol { '00088/2012' }
  budget_unit { BudgetUnit.make!(:secretaria_de_educacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
end

AdministrativeProcess.blueprint(:compra_com_itens_2) do
  process { 2 }
  year { 2013 }
  date { Date.new(2013, 3, 7) }
  protocol { '00089/2012' }
  budget_unit { BudgetUnit.make!(:secretaria_de_educacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
end
