# encoding: utf-8
RevenueSubcategory.blueprint(:receita_tributaria) do
  code { '1' }
  description { 'RECEITA TRIBUTÁRIA' }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
end

RevenueSubcategory.blueprint(:outras_receitas_correntes) do
  code { '9' }
  description { 'OUTRAS RECEITAS CORRENTES - INTRA-ORÇAMENTÁRIAS' }
  revenue_category { RevenueCategory.make!(:receitas_correntes) }
end
