class Report::TotalPurchasePerElementAndNatureController < Report::BaseController
  report_class TotalPurchasePerElementAndNatureReport, :repository => TotalPurchasePerElementAndNatureSearcher

  def show
    @licitation_processes = get_total_purchase_per_element_and_nature

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_total_purchase_per_element_and_nature

    @licitation_processes = LicitationProcess.
        where(total_purchase_per_element_and_nature_report_params.except!(:creditor_id))
  end

  def total_purchase_per_element_and_nature_report_params
    @params = params.require(:total_purchase_per_element_and_nature_report).permit(:process, :creditor_id)
  end
end
