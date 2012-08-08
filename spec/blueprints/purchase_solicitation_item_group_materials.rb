PurchaseSolicitationItemGroupMaterial.blueprint(:reparo) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_2013) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo_2013)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_arame_farpado) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:arame_farpado) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo)] }
end
