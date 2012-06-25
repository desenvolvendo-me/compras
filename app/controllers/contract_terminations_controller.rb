class ContractTerminationsController < CrudController
  def index
    @parent = Contract.find(params[:contract_id])

    super
  end

  def new
    object = build_resource
    object.year = Date.current.year
    object.number = object.next_number
    object.contract = Contract.find(params[:contract_id])

    super
  end

  def create
    create!{ contract_terminations_path(:contract_id => resource.contract_id) }
  end

  def update
    update!{ contract_terminations_path(:contract_id => resource.contract_id) }
  end

  protected

  def create_resource(object)
    object.year = Date.current.year

    super
  end
end
