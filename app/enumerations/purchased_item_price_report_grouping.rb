class PurchasedItemPriceReportGrouping < EnumerateIt::Base
  associate_values :licitation, :creditor, :material
end
