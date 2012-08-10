class BudgetStructuresController < CrudController
  has_scope :synthetic, :type => :boolean

  def update
    BudgetStructureResponsibleEndDateGenerator.new(resource).change!

    super
  end
end
