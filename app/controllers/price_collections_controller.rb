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

  def update
    if params[:commit] == 'Apurar'
      generator = PriceCollectionClassificationGenerator.new(resource)

      resource.transaction do
        generator.generate!
      end

      redirect_to price_collection_path(resource)
    else
      super
    end
  end

  def show
    render :layout => 'report'
  end

  protected

  def default_filters
    { :year => lambda { Date.current.year } }
  end

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.code}/#{resource.year}" }
  end

  def create_resource(object)
    object.status = Status::ACTIVE

    if super
      CreditorUserCreator.new(object, self).generate
    end
  end

  def update_resource(object, attributes)
    if super
      CreditorUserCreator.new(object, self).generate

      return false
    end
  end

  def should_not_be_annuled!
    if resource.annulled?
      raise Exceptions::Unauthorized
    end
  end
end
