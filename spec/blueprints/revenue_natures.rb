# encoding: utf-8
RevenueNature.blueprint(:imposto) do
  entity { Entity.make!(:detran) }
  year { 2009 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  classification { '12344569' }
  revenue_rubric { RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda) }
  specification { 'Imposto s/ Propriedade Predial e Territ. Urbana' }
  kind { RevenueNatureKind::BOTH }
  docket { 'Registra o valor da arrecadação da receita' }
end
