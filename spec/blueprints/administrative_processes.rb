# encoding: utf-8
AdministrativeProcess.blueprint(:compra_de_cadeiras) do
  process { 1 }
  year { 2012 }
  date { '2012-03-07' }
  protocol { '00099/2012' }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  value_estimated { "500,50" }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::PRESENCE_TRADING }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
end

AdministrativeProcess.blueprint(:compra_de_computadores) do
  process { 2 }
  year { 2013 }
  date { '2012-03-07' }
  protocol { '00099/2012' }
  organogram { Organogram.make!(:secretaria_de_educacao) }
  value_estimated { "500,50" }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { AdministrativeProcessModality::PRESENCE_TRADING }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de computadores' }
  responsible { Employee.make!(:sobrinho) }
  status { AdministrativeProcessStatus::WAITING }
end
