class PledgeLiquidationCancellationsController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = resource_class.last.date if resource_class.any?

    super
  end
end
