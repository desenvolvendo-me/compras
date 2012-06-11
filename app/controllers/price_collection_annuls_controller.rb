class PriceCollectionAnnulsController < CrudController
  actions :all, :except => [:destroy, :index, :show]

  def new
    @price_collection = PriceCollection.find params[:price_collection_id]

    object = build_resource
    object.date = Date.current
    object.employee = current_user.authenticable
    object.price_collection = @price_collection

    super
  end

  def create
    create!{ edit_price_collection_path(resource.price_collection) }
  end

  protected

  def create_resource(object)
    object.transaction do
      PriceCollectionAnnulment.new(object.price_collection).change! if super
    end
  end
end
