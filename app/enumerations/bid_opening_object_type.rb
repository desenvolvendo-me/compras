class BidOpeningObjectType < EnumerateIt::Base
  associate_values :purchase_and_services,
    :construction_and_engineering_services,
    :disposals_of_assets,
    :concessions_and_permits,
    :call_notice
end
