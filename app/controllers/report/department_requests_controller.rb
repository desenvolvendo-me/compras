class Report::DepartmentRequestsController < Report::BaseController
  report_class DepartmentRequestReport, :repository => DepartmentRequestSearcher

  def show
    @department = get_department_request()
    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_department_request
    @departments = Department.
        where(' LOWER( description ) LIKE ?',
              "%#{department_request_report_params[:department].downcase unless
                  department_request_report_params[:department].nil? }%")
  end

  def department_request_report_params
    @params = params.require(:department_request_report).permit(
        :department
    )
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:department) if params[:department].blank?
    params
  end

end
