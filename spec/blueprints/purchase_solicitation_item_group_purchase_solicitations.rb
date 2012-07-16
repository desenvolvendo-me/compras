PurchaseSolicitationItemGroupPurchaseSolicitation.blueprint(:reparo) do
  purchase_solicitation { PurchaseSolicitation.make!(:reparo) }
end

PurchaseSolicitationItemGroupPurchaseSolicitation.blueprint(:reparo_2013) do
  purchase_solicitation { PurchaseSolicitation.make!(:reparo_2013) }
end
