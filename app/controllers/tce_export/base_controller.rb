class TceExport::BaseController < CrudController
  before_filter :authorize_resource!

  def authorize_resource!
    authorize! action_name, "tce_export_#{controller_name}"
  end
end
