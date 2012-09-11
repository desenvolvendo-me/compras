PriceRegistrationItem.blueprint(:antivirus) do
  administrative_process_budget_allocation_item { AdministrativeProcessBudgetAllocationItem.make(:item) }
  price_registration_budget_structures {
    [ PriceRegistrationBudgetStructure.make(:secretaria_de_educacao, :price_registration_item => object),
      PriceRegistrationBudgetStructure.make(:secretaria_de_desenvolvimento, :price_registration_item => object)
    ]
  }
end
