# encoding: utf-8
RevenueNature.blueprint(:imposto) do
  descriptor { Descriptor.make!(:detran_2009) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
  revenue_source { RevenueSource.make!(:impostos) }
  revenue_rubric { RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda) }
  classification { '12.34' }
  revenue_nature { '1.1.1.2.12.34' }
  specification { 'Imposto s/ Propriedade Predial e Territ. Urbana' }
  kind { RevenueNatureKind::BOTH }
  docket { 'Registra o valor da arrecadação da receita' }
end

RevenueNature.blueprint(:imposto_sobre_renda) do
  descriptor { Descriptor.make!(:detran_2012) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
  revenue_source { RevenueSource.make!(:impostos) }
  revenue_rubric { RevenueRubric.make!(:imposto_sobre_patrimonio_e_a_renda) }
  classification { '12.34' }
  revenue_nature { '1.1.1.2.12.34' }
  specification { 'Imposto sobre a renda' }
  kind { RevenueNatureKind::BOTH }
  docket { 'Registra o valor da arrecadação da receita referente a renda' }
end
