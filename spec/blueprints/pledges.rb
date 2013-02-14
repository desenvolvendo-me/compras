Pledge.blueprint(:empenho_em_quinze_dias) do
  descriptor { Descriptor.make!(:detran_2012) }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { Date.current + 15.days }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 9.99 }
  material_kind { MaterialKind::PUBLIC }
  contract { Contract.make!(:primeiro_contrato) }
  modality { Modality::COMPETITION }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:founded_debt) do
  descriptor { Descriptor.make!(:detran_2012) }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { Date.current + 15.days }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 9.99 }
  material_kind { MaterialKind::PUBLIC }
  modality { Modality::COMPETITION }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:primeiro_contrato) }
  creditor { Creditor.make!(:wenderson_sa) }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end
