class Report::MaterialsController < Report::BaseController
  report_class MaterialReport, :repository => MaterialSearcher

  def show
    @material = get_material()

    @report = report_instance

    if @report.valid?
      render layout: 'report'
    else
      render :new
    end
  end

  private

  def get_material
    @material = Material.
        where(material_report_params.except!(:description)).
        where(' LOWER( description ) LIKE ?',
              "%#{material_report_params[:description].downcase unless
                  material_report_params[:description].nil? }%")
  end

  def material_report_params
    @params = params.require(:material_report).permit(
        :description, :material_classification,
        :combustible, :material_class_id,:active,:medicine
    )
    normalize_attributes(@params)
  end

  def normalize_attributes(params)
    params.delete(:material_classification) if params[:material_classification].blank?
    params.delete(:combustible) if params[:combustible].blank?
    params.delete(:material_class_id) if params[:material_class_id].blank?
    params.delete(:active) unless params[:active]=='true'
    params.delete(:medicine) unless params[:medicine]=='true'
    params.delete(:combustible) unless params[:combustible]=='true'
    params.delete(:description) if params[:description].blank?
    params
  end

end
