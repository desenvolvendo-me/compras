class ContractsController < CrudController
  has_scope :founded, :type => :boolean
  has_scope :management, :type => :boolean

  def new
    object = build_resource
    object.year = Date.current.year

    super
  end

  def next_sequential
    render :nothing => true and return if params[:year].blank?

    respond_to do |format|
      format.json do
        render :json => { :sequential => Contract.next_sequential(params[:year]) }
      end
    end
  end

  protected

  def default_filters
    { :year => lambda { Date.current.year } }
  end

  def create_resource(object)
    object.sequential_number = Contract.next_sequential(object.year)

    super
  end
end
