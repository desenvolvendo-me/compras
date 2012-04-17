# encoding: utf-8
RevenueNature.blueprint(:imposto) do
  entity { Entity.make!(:detran) }
  year { 2009 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
  revenue_source { RevenueSource.make!(:impostos) }
  revenue_rubric { RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda) }
  classification { '1234' }
  full_code { '1.1.1.2.1234' }
  specification { 'Imposto s/ Propriedade Predial e Territ. Urbana' }
  kind { RevenueNatureKind::BOTH }
  docket { 'Registra o valor da arrecadação da receita' }
end

RevenueNature.blueprint(:imposto_sobre_renda) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
  revenue_source { RevenueSource.make!(:impostos) }
  revenue_rubric { RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda) }
  classification { '1234' }
  full_code { '1.1.1.2.1234' }
  specification { 'Imposto sobre a renda' }
  kind { RevenueNatureKind::BOTH }
  docket { 'Registra o valor da arrecadação da receita referente a renda' }
end
