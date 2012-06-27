BudgetRevenue.blueprint(:reforma) do
  descriptor { Descriptor.make!(:detran_2012) }
  code { '1' }
  revenue_nature { RevenueNature.make!(:imposto) }
  capability { Capability.make!(:reforma) }
  kind { BudgetRevenueKind::AVERAGE }
end
