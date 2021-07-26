class PurchaseProcessObjectType < EnumerateIt::Base
  associate_values :concessions,
                   :construction_and_engineering_services,
                   :disposals_of_assets,
                   :permits,
                   :property_lease,
                   :purchase_and_services
                   :property_lease
end
