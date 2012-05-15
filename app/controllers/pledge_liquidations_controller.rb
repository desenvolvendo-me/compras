class PledgeLiquidationsController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = resource_class.last.date if resource_class.any?

    super
  end

  protected

  def create_resource(object)
    if super
      PledgeParcelMovimentationGenerator.new(object).generate!
    end
  end
end
