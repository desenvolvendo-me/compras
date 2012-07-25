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

RevenueNature.blueprint(:receitas_intra_orcamentaria) do
  descriptor { Descriptor.make!(:secretaria_de_educacao_2011) }
  regulatory_act { RegulatoryAct.make!(:emenda) }
  revenue_category { RevenueCategory.make!(:receitas_correntes) }
  revenue_subcategory { RevenueSubcategory.make!(:outras_receitas_correntes) }
  revenue_source { RevenueSource.make!(:multas) }
  revenue_rubric { RevenueRubric.make!(:multa) }
  classification { '00.00' }
  revenue_nature { '7.9.4.0.00.00' }
  specification { 'RECEITAS INTRA-ORÇAMENTÁRIA DECORRENTES DE APORTES PERIÓDICOS PARA AMORTIZAÇÃO DE DÉFICIT ATUARIAL DO RPPS' }
  kind { RevenueNatureKind::ANALYTICAL }
  docket { 'INCLUSÃO - JANEIRO 2012' }
end
