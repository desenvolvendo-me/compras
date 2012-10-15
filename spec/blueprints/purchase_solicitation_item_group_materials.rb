PurchaseSolicitationItemGroupMaterial.blueprint(:reparo) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo,
                                                      :service_status => PurchaseSolicitationServiceStatus::LIBERATED)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_2013) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:arame_farpado) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo_2013,
                                                      :service_status => PurchaseSolicitationServiceStatus::LIBERATED)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_arame_farpado) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:arame_farpado) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo,
                                                      :service_status => PurchaseSolicitationServiceStatus::LIBERATED)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_desenvolvimento) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo_desenvolvimento,
                                                      :service_status => PurchaseSolicitationServiceStatus::LIBERATED)] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_office) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [PurchaseSolicitation.make(:reparo_office,
                                                      :service_status => PurchaseSolicitationServiceStatus::LIBERATED)] }
end
