PurchaseSolicitationItemGroup.blueprint(:antivirus) do
  material { Material.make!(:antivirus) }
  purchase_solicitation_item_group_purchase_solicitations {
    [ PurchaseSolicitationItemGroupPurchaseSolicitation.make(:reparo, :purchase_solicitation_item_group => object) ]
  }
end

PurchaseSolicitationItemGroup.blueprint(:reparo_2013) do
  material { Material.make!(:antivirus) }
  purchase_solicitation_item_group_purchase_solicitations {
    [ PurchaseSolicitationItemGroupPurchaseSolicitation.make(:reparo_2013, :purchase_solicitation_item_group => object) ]
  }
end
