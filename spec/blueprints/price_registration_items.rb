PriceRegistrationItem.blueprint(:antivirus) do
  purchase_process_item { PurchaseProcessItem.make(:item) }
  price_registration_budget_structures {
    [ PriceRegistrationBudgetStructure.make(:secretaria_de_educacao, :price_registration_item => object),
      PriceRegistrationBudgetStructure.make(:secretaria_de_desenvolvimento, :price_registration_item => object)
    ]
  }
end
