class BudgetStructuresController < CrudController
  has_scope :synthetic, :type => :boolean

  protected

  def update_resource(object, attributes)
    old_object = object.dup
    object.localized.assign_attributes(*attributes)

    if old_object.code == object.code && old_object.level != object.level
      object.code = ''
    end

    object.save
  end
end
