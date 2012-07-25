# encoding: utf-8
RevenueCategory.blueprint(:receita_tributaria) do
  code { '1' }
  description { 'RECEITAS CORRENTES' }
end

RevenueCategory.blueprint(:receitas_correntes) do
  code { '7' }
  description { 'RECEITAS CORRENTES - INTRA-ORÇAMENTÁRIAS' }
end
