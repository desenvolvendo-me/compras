RevenueSource.blueprint(:impostos) do
  code { '1' }
  description { 'IMPOSTOS' }
  revenue_subcategory { RevenueSubcategory.make!(:receita_tributaria) }
end
