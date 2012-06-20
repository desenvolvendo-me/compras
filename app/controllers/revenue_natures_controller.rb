class RevenueNaturesController < CrudController
  def create
    object = build_resource
    RevenueNatureCodeGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    RevenueNatureCodeGenerator.new(object).generate!

    super
  end
end
