class ReserveFundRequestsController < CrudController
  defaults resource_class: LicitationProcess

  def index
    collection = LicitationProcess.all
  end
end
