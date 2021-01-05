class PriceCollectionsController < CrudController
  actions :all, :except => :destroy
  before_filter :should_not_be_annuled!, :only => [:update, :classification]
  has_scope :by_years, type: :boolean, default: true, only: [:index]

  def create
    create! do |success, failure|
      success.html { redirect_to edit_price_collection_path(resource) }
    end
  end

  def new
    object = build_resource
    object.date = Date.current
    object.year = Date.current.year
    object.status = Status::ACTIVE

    super
  end

  def show
    render :layout => 'report'
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_price_collection_path(resource) }
    end
  end

  def classification
    generator = PriceCollectionClassificationGenerator.new(resource)

    resource.transaction do
      generator.generate!
    end

    redirect_to price_collection_path(resource)
  end

  def edit_proposal
    @proposal = resource.price_collection_proposals.where(id: params[:price_collection_proposal_id])

    render 'edit_price_collection_proposals', layout: false
  end

  protected

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
