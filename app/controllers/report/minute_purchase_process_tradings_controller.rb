class Report::MinutePurchaseProcessTradingsController < Report::BaseController
  report_class MinutePurchaseProcessTradingReport, :repository => MinutePurchaseProcessTradingSearcher

  def show
    @report = report_instance
    @report.licitation_process_id = params[:licitation_process_id]

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end
