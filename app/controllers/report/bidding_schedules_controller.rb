class Report::BiddingSchedulesController < Report::BaseController
  report_class BiddingScheduleReport, :repository => BiddingScheduleSearcher

  def new
    @report = report_instance

    unless params[:bidding_schedule_report]
      @report.start_date = I18n.l Date.current
      @report.end_date = I18n.l Date.current
    end
  end
end
