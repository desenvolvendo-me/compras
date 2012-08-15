class BudgetStructuresController < CrudController
  has_scope :synthetic, :type => :boolean

  protected

  def update_resource(object, resource_params)
    object.localized.assign_attributes(*resource_params)

    BudgetStructureResponsibleEndDateGenerator.new(object).change!

    object.save
  end
end
