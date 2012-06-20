class ContractsController < CrudController
  has_scope :founded, :type => :boolean
  has_scope :management, :type => :boolean

  def new
    object = build_resource
    object.year = Date.current.year

    super
  end

  def next_sequential
    render :nothing => true and return if params[:entity_id].blank? || params[:year].blank?

    respond_to do |format|
      format.json do
        render :json => { :sequential => Contract.next_sequential(params[:year], params[:entity_id]) }
      end
    end
  end

  protected

  def create_resource(object)
    object.sequential_number = Contract.next_sequential(object.year, object.entity_id)

    super
  end
end
