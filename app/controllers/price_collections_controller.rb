class PriceCollectionsController < CrudController
  actions :all, :except => :destroy

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

    ProviderUserCreator.new(object).generate if super
  end
end
