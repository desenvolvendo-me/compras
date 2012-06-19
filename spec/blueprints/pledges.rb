Pledge.blueprint(:empenho) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { "9.99" }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [PledgeParcel.make!(:vencimento)]}
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_com_dois_vencimentos) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 200 }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio_computador) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [
    PledgeParcel.make!(:vencimento_primario),
    PledgeParcel.make!(:vencimento_secundario)
  ] }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_em_quinze_dias) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  reserve_fund { ReserveFund.make!(:detran_2012) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { Date.current + 15.days }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { 9.99 }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [PledgeParcel.make!(:vencimento_para_empenho_em_quinze_dias)] }
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_saldo_maior_mil) do
  entity { Entity.make!(:detran) }
  year { 2011 }
  reserve_fund { ReserveFund.make!(:reparo_2011) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  pledge_type { PledgeType::GLOBAL }
  budget_allocation { BudgetAllocation.make!(:reparo_2011) }
  value { "9.99" }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [PledgeParcel.make!(:vencimento)]}
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_estimativo) do
  entity { Entity.make!(:detran) }
  year { 2011 }
  reserve_fund { ReserveFund.make!(:reparo_2011) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  pledge_type { PledgeType::ESTIMATED }
  budget_allocation { BudgetAllocation.make!(:reparo_2011) }
  value { 9.99 }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [PledgeParcel.make!(:vencimento)]}
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_ordinario) do
  entity { Entity.make!(:detran) }
  year { 2010 }
  reserve_fund { ReserveFund.make!(:reparo_2011) }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  pledge_type { PledgeType::ORDINARY }
  budget_allocation { BudgetAllocation.make!(:reparo_2011) }
  value { 9.99 }
  material_kind { MaterialKind::PUBLIC }
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  contract { Contract.make!(:primeiro_contrato) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:contrato_detran) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  pledge_parcels { [PledgeParcel.make!(:vencimento)]}
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end
