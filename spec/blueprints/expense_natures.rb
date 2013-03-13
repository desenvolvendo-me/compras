# encoding: utf-8
ExpenseNature.blueprint(:vencimento_e_salarios) do
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