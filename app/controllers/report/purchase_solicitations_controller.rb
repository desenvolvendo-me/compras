class Report::PurchaseSolicitationsController < Report::BaseController
  report_class PurchaseSolicitationReport, :repository => PurchaseSolicitationSearcher
end
