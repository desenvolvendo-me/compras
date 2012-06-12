class PriceCollectionsController < CrudController
  actions :all, :except => :destroy
  before_filter :should_not_be_annuled!, :only => :update

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = Status::ACTIVE

    super
  end

  protected

  def create_resource(object)
    object.collection_number = object.next_collection_number
    object.status = Status::ACTIVE

    object.transaction do
      return unless super

      ProviderUserCreator.new(object).generate
    end
  end

  def update_resource(object, attributes)
    object.transaction do
      return unless super

      ProviderUserCreator.new(object).generate
    end
  end

  def should_not_be_annuled!
    if resource.annulled?
      raise Exceptions::Unauthorized
    end
  end
end
