class Generator::GeneratorSupplyOrdersController < Generator::BaseController
  def new
    object = build_resource
    super
  end

  def create
    create!(notice: I18n.t("tce_export/monthly_monitoring.messages.success")) do |success, failure|
      success.html { redirect_to edit_resource_path(resource) }
      failure.html { render 'new' }
    end
  end

  def cancel
    if cancel_resource
      flash[:notice] = I18n.t("tce_export/monthly_monitoring.messages.cancelled")
    else
      flash[:alert] = I18n.t("tce_export/monthly_monitoring.messages.cant_cancel")
    end

    redirect_to edit_resource_path(resource)
  end

  def without_sidekiq
    generetor = Generator::GeneratorSupplyOrder.find(params[:id])
    generetor.create_supply_orders
    redirect_to edit_resource_path(resource)
  end

  protected

  def create_resource(object)
    object.status = MonthlyMonitoringStatus::PROCESSING
    object.customer = current_customer
    object.prefecture = current_prefecture
    object.city_code = current_prefecture.tce_mg_code

    if super
      job_id = Generator::GeneratorSupplyOrdersWorker.perform_async(current_customer.id, object.id)
      object.update_attribute :job_id, job_id
    end
  end

  private

  def cancel_resource
    ProcessingJobCancellation.cancel!(resource)
  end
end
