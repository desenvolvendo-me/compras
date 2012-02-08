# encoding: utf-8
EconomicClassificationOfExpenditure.blueprint(:vencimento_e_salarios) do
  entity { Entity.make!(:detran) }
  administractive_act { AdministractiveAct.make!(:sopa) }
  economic_classification_of_expenditure { '3.1.90.11.01.00.00.00' }
  kind { EconomicClassificationOfExpenditureKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
end
