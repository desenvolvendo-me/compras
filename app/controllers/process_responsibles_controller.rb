class ProcessResponsiblesController < CrudController
  defaults resource_class: LicitationProcess

  def index
    collection = LicitationProcess.all
  end

  def edit
    ProcessResponsibleCreator.create!(resource)
  end
end
