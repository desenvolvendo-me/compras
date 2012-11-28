PurchaseSolicitationItemGroupMaterial.blueprint(:reparo) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [
    PurchaseSolicitation.make(:reparo,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria,
          :items => [
            PurchaseSolicitationBudgetAllocationItem.make!(:item,
              :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
          ]
        )
      ]
    )
  ] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_2013) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:arame_farpado) }
  purchase_solicitations { [
    PurchaseSolicitation.make(:reparo_2013,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_2013,
          :items => [
            PurchaseSolicitationBudgetAllocationItem.make!(:arame_farpado,
              :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
          ]
        )
      ]
    )
  ] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_arame_farpado) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:arame_farpado) }
  purchase_solicitations { [
    PurchaseSolicitation.make(:reparo,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria,
          :items => [
            PurchaseSolicitationBudgetAllocationItem.make!(:item,
              :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
          ]
        )
      ]
    )
  ] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_desenvolvimento) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:antivirus) }
  purchase_solicitations { [
    PurchaseSolicitation.make(:reparo_desenvolvimento,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria,
          :items => [
            PurchaseSolicitationBudgetAllocationItem.make!(:item,
              :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
          ]
        )
      ]
    )
  ] }
end

PurchaseSolicitationItemGroupMaterial.blueprint(:reparo_office) do
  purchase_solicitation_item_group { nil }
  material { Material.make!(:office) }
  purchase_solicitations { [
    PurchaseSolicitation.make(:reparo_office,
      :service_status => PurchaseSolicitationServiceStatus::LIBERATED,
      :purchase_solicitation_budget_allocations => [
        PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office,
          :items => [
            PurchaseSolicitationBudgetAllocationItem.make!(:office,
              :status => PurchaseSolicitationBudgetAllocationItemStatus::GROUPED)
          ]
        )
      ]
    )
  ] }
end
