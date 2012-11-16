SupplyAuthorization.blueprint(:compra_2012) do
  year { 2012 }
  code { 1 }
  direct_purchase { DirectPurchase.make!(:compra_nao_autorizada) }
end

SupplyAuthorization.blueprint(:nohup) do
  year { 2012 }
  code { 1 }
  direct_purchase { DirectPurchase.make!(:company_purchase) }
end
