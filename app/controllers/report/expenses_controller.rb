class Report::ExpensesController < Report::BaseController
  report_class ExpenseReport, repository: ExpenseSearcher

  def show
    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

end