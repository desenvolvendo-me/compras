# encoding: utf-8
ExpenseNature.blueprint(:vencimento_e_salarios) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  full_code { '3.0.10.01.12345569' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
  expense_element { ExpenseElement.make!(:aposentadorias) }
  expense_split { '12345569' }
end

ExpenseNature.blueprint(:compra_de_material) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  full_code { '3.0.10.01.12345569' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Compra de Material' }
  docket { 'Registra o valor das despesas com compra de material' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
  expense_element { ExpenseElement.make!(:aposentadorias) }
  expense_split { '12345569' }
end
