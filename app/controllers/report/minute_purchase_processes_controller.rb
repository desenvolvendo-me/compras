class Report::MinutePurchaseProcessesController < Report::BaseController
  report_class MinutePurchaseProcessReport, :repository => MinutePurchaseProcessSearcher

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
