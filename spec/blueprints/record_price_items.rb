RecordPriceItem.blueprint(:antivirus) do
  administrative_process_budget_allocation_item { AdministrativeProcessBudgetAllocationItem.make(:item) }
  record_price_budget_structures {
    [ RecordPriceBudgetStructure.make(:secretaria_de_educacao, :record_price_item => object),
      RecordPriceBudgetStructure.make(:secretaria_de_desenvolvimento, :record_price_item => object)
    ]
  }
end
