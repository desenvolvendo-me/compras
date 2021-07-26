MaterialsControl.blueprint(:antivirus_general) do
  warehouse { ::FactoryGirl::Preload.factories['Warehouse'][:general] }
  material { Material.make!(:antivirus) }
  minimum_quantity { 10.0 }
  maximum_quantity { 20.0 }
  average_quantity { 15.0 }
  replacement_quantity { 5.0 }
end
