# encoding: utf-8
ExpenseNature.blueprint(:vencimento_e_salarios) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_element { '3.1.90.11.01.00.00.00' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
end

ExpenseNature.blueprint(:compra_de_material) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_element { '2.2.22.11.01.00.00.00' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Compra de Material' }
  docket { 'Registra o valor das despesas com compra de material' }
  expense_group { ExpenseGroup.make!(:restos_a_pagar) }
  expense_category { ExpenseCategory.make!(:despesa_corrente) }
  expense_modality { ExpenseModality.make!(:transferencias_intragovernamentais) }
end
