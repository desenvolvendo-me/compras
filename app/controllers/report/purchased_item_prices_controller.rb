class Report::PurchasedItemPricesController < Report::BaseController
  report_class PurchasedItemPriceReport, repository: PurchasedItemPriceSearcher
end
