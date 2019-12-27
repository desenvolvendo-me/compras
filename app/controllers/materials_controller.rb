class MaterialsController < CrudController
  has_scope :term, :allow_blank => true
  has_scope :by_licitation_process, :allow_blank => true

  # def create
  #   object = build_resource
  #   MaterialCodeGenerator.new(object).generate!
  #
  #   super
  # end

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
