# encoding: utf-8
ExpenseElement.blueprint(:vencimento_e_salarios) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_element { '3.1.90.11.01.00.00.00' }
  kind { ExpenseElementKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
end

ExpenseElement.blueprint(:compra_de_material) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_element { '2.2.22.11.01.00.00.00' }
  kind { ExpenseElementKind::ANALYTICAL }
  description { 'Compra de Material' }
  docket { 'Registra o valor das despesas com compra de material' }
end
