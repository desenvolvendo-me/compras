DirectPurchaseLiberation.blueprint(:compra_liberada) do
  direct_purchase { DirectPurchase.make!(:compra, :status => DirectPurchaseStatus::AUTHORIZED) }
  employee { Employee.make!(:sobrinho) }
  evaluation { DirectPurchaseStatus::AUTHORIZED }
  description { 'Foo bar' }
end
