class BudgetStructuresController < CrudController
  has_scope :synthetic, :type => :boolean
  has_scope :except_ids, :type => :array

  protected

  def update_resource(object, resource_params)
    object.localized.assign_attributes(*resource_params)

    BudgetStructureResponsibleEndDateGenerator.new(object).change!

    object.save
  end
end
