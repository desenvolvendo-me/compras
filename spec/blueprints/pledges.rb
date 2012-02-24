Pledge.blueprint(:empenho) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  commitment_type { CommitmentType.make!(:primeiro_empenho) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { "9.99" }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  management_contract { ManagementContract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_number { '001' }
  licitation_year { '2012' }
  licitation { '001/2012' }
  process_number { '002' }
  process_year { '2013' }
  process { '002/2013' }
  description { 'Descricao' }
  founded_debt_contract { FoundedDebtContract.make!(:contrato_detran) }
  creditor { Creditor.make!(:nohup) }
end
