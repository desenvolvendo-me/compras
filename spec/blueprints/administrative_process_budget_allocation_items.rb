# encoding: utf-8
AdministrativeProcessBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  quantity { 2 }
  unit_price { 10.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame) do
  material { Material.make!(:arame_comum) }
  quantity { 1 }
  unit_price { 10.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame_farpado) do
  material { Material.make!(:arame_farpado) }
  quantity { 2 }
  unit_price { 30.0 }
end
