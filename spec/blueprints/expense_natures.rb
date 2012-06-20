# encoding: utf-8
ExpenseNature.blueprint(:vencimento_e_salarios) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.0.10.01.12' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
  expense_element { ExpenseElement.make!(:aposentadorias) }
  expense_split { '12' }
end

ExpenseNature.blueprint(:compra_de_material) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.0.10.01.11' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Compra de Material' }
  docket { 'Registra o valor das despesas com compra de material' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
  expense_element { ExpenseElement.make!(:aposentadorias) }
  expense_split { '11' }
end

ExpenseNature.blueprint(:despesas_correntes) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '4.4.20.03.11' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Despesas Correntes' }
  docket { 'Registra o valor das despesas' }
  expense_group { ExpenseGroup.make!(:investimentos) }
  expense_category { ExpenseCategory.make!(:despesa_de_capital) }
  expense_modality { ExpenseModality.make!(:transferencias_a_uniao) }
  expense_element { ExpenseElement.make!(:pensoes) }
  expense_split { '11' }
end
