# encoding: utf-8
RevenueSubcategory.blueprint(:receita_tributaria) do
  code { '1' }
  description { 'RECEITA TRIBUTÁRIA' }
  revenue_category { RevenueCategory.make!(:receita_tributaria) }
end
