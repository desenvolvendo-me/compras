class RevenueNaturesController < CrudController
  def create
    object = build_resource
    RevenueNatureFullCodeGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    RevenueNatureFullCodeGenerator.new(object).generate!

    super
  end
end
