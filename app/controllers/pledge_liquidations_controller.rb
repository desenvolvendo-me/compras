class PledgeLiquidationsController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.date = resource_class.last.date if resource_class.any?
    object.status = PledgeLiquidationStatus::ACTIVE

    super
  end

  def create
    object = build_resource
    object.status = PledgeLiquidationStatus::ACTIVE

    super
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      PledgeParcelMovimentationGenerator.new(object).generate!
    end
  end
end
