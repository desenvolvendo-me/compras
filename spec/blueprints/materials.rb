Material.blueprint(:manga) do
  materials_group { MaterialsGroup.make!(:first) }
  materials_class { MaterialsClass.make!(:hortifrutigranjeiros) }
  code { "01" }
  name { "Manga" }
  description { "Fruta manga" }
  minimum_stock_balance { 100 }
  reference_unit { ReferenceUnit.make!(:unidade) }
  manufacturer { "Plantador" }
  perishable { true }
  storable { true }
  combustible { false }
  material_characteristic { "material" }
  service_type { ServiceType.make!(:reparos) }
  material_type { 'consumption' }
  stn_ordinance { "portaria" }
  expense_element { "elemento" }
end
