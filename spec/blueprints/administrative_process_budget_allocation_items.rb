# encoding: utf-8
AdministrativeProcessBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  quantity { 2 }
  unit_price { 10.0 }
end
