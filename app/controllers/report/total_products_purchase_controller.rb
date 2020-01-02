class Report::TotalProductsPurchaseController < Report::BaseController
  report_class TotalProductsPurchaseReport, :repository => TotalProductsPurchaseSearcher

  def show
    @licitation_processes = get_total_products_purchase

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_total_products_purchase

    @licitation_processes = LicitationProcess.
        where(total_products_purchase_report_params.except!(:creditor_id))
  end

  def total_products_purchase_report_params
    @params = params.require(:total_products_purchase_report).permit(:process, :creditor_id)
  end
end
