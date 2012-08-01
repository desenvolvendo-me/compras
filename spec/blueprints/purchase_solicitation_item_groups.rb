PurchaseSolicitationItemGroup.blueprint(:antivirus) do
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo,
      :purchase_solicitation_item_group => object)
    ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:reparo_2013) do
  purchase_solicitation_item_group_materials {
    [PurchaseSolicitationItemGroupMaterial.make(
      :reparo_2013,
      :purchase_solicitation_item_group => object)
    ]
  }
end
