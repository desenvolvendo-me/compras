Pledge.blueprint(:empenho) do
  descriptor { Descriptor.make!(:detran_2012) }
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
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_com_dois_vencimentos) do
  descriptor { Descriptor.make!(:detran_2012) }
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
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_em_quinze_dias) do
  descriptor { Descriptor.make!(:detran_2012) }
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
  pledge_category { PledgeCategory.make!(:geral) }
  expense_kind { ExpenseKind.make!(:pagamentos) }
  pledge_historic { PledgeHistoric.make!(:semestral) }
  licitation_modality { LicitationModality.make!(:publica) }
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  description { 'Descricao' }
  founded_debt_contract { Contract.make!(:primeiro_contrato) }
  creditor { Creditor.make!(:wenderson_sa) }
  pledge_items { [PledgeItem.make!(:item)]}
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_saldo_maior_mil) do
  descriptor { Descriptor.make!(:detran_2011) }
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
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_estimativo) do
  descriptor { Descriptor.make!(:detran_2011) }
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
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end

Pledge.blueprint(:empenho_ordinario) do
  descriptor { Descriptor.make!(:detran_2010) }
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
  expense_nature { ExpenseNature.make!(:vencimento_e_salarios) }
end
