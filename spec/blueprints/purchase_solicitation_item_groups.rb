PurchaseSolicitationItemGroup.blueprint(:antivirus) do
  description { 'Agrupamento de antivirus' }
  status { PurchaseSolicitationItemGroupStatus::PENDING }
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo,
      :purchase_solicitation_item_group => object)
    ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:reparo_2013) do
  description { 'Agrupamento de reparo 2013' }
  status { PurchaseSolicitationItemGroupStatus::PENDING }
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo_2013,
      :purchase_solicitation_item_group => object)
    ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:reparo_arame_farpado) do
  description { 'Agrupamento de arame farpado' }
  status { PurchaseSolicitationItemGroupStatus::PENDING }
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo_arame_farpado,
      :purchase_solicitation_item_group => object)
    ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:antivirus_desenvolvimento) do
  description { 'Agrupamento de antivirus desenvolvimento' }
  status { PurchaseSolicitationItemGroupStatus::PENDING }
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo_desenvolvimento,
      :purchase_solicitation_item_group => object)
    ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:office) do
  description { 'Agrupamento de office' }
  status { PurchaseSolicitationItemGroupStatus::PENDING }
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo_office,
      :purchase_solicitation_item_group => object)
    ]
  }
end
