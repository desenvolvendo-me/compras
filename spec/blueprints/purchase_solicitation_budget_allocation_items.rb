PurchaseSolicitationBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  brand { "Norton" }
  quantity { 3 }
  unit_price { 200.0 }
  status { PurchaseSolicitationBudgetAllocationItemStatus::PENDING }
end

PurchaseSolicitationBudgetAllocationItem.blueprint(:arame_farpado) do
  material { Material.make!(:arame_farpado) }
  brand { "Arame" }
  quantity { 99 }
  unit_price { 200.0 }
  status { PurchaseSolicitationBudgetAllocationItemStatus::PENDING }
end
