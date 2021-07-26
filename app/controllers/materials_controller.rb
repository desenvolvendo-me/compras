class MaterialsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_licitation_process, :allow_blank => true
  has_scope :by_licitation_process_status, :allow_blank => true
  has_scope :by_supply_order, :allow_blank => true
  has_scope :material_of_supply_request, :type => :array

  # def create
  #   object = build_resource
  #   MaterialCodeGenerator.new(object).generate!
  #
  #   super
  # end
  def api_show
    material = Material.find(params[:id])

    render :json => material.to_json(include:[:reference_unit,:material_class])
  end
  protected

  # def update_resource(object, attributes)
  #   object.localized.assign_attributes(*attributes)
  #
  #   MaterialCodeGenerator.new(object).generate!
  #
  #   if super
  #     object.transaction do
  #       MaterialClassFractionationUpdater.update(object.reload)
  #     end
  #
  #     return true
  #   end
  #
  #   false
  # end
end
