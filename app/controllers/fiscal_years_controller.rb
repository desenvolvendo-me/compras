class FiscalYearsController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year

    super
  end
end
