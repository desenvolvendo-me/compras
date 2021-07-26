ListPurchaseSolicitation.blueprint(:principal) do
  balance { 0 }
  consumed_value { 0 }
  expected_value { 0 }
  resource_source { 0 }
  purchase_solicitation { PurchaseSolicitation.make!(:reparo) }
end