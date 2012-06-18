RevenueAccounting.blueprint(:reforma) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  code { '1' }
  revenue_nature { RevenueNature.make!(:imposto) }
  capability { Capability.make!(:reforma) }
  kind { RevenueAccountingKind::AVERAGE }
end
