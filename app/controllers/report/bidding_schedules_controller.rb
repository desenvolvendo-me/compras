class Report::BiddingSchedulesController < Report::BaseController
  report_class BiddingScheduleReport, repository: BiddingScheduleSearcher
end
