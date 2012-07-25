# encoding: utf-8
RevenueSource.blueprint(:impostos) do
  code { '1' }
  description { 'IMPOSTOS' }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
end

RevenueSource.blueprint(:multas) do
  code { '1' }
  description { 'MULTAS E JUROS DE MORA - INTRA-ORÇAMENTÁRIAS' }
  revenue_subcategory { RevenueSubcategory.make!(:outras_receitas_correntes) }
end
