class Report::CreditorMaterialsController < Report::BaseController
  report_class CreditorMaterialReport

  def show
    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end
end