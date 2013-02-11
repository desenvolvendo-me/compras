class ContractTerminationsController < CrudController
  actions :all, :except => [:destroy, :index, :show]

  before_filter :get_parent
  before_filter :block_contract_not_allowed, :only => [:new, :create]

  def new
    object = build_resource
    object.year = Date.current.year
    object.number = object.next_number
    object.contract = @parent

    super
  end

  def create
    create!{ edit_contract_path(@parent) }
  end

  def update
    update!{ edit_contract_path(@parent) }
  end

  protected

  def create_resource(object)
    object.year = Date.current.year

    super
  end

  def contract_id
    return params[:contract_id] if params[:contract_id]
    return params[:contract_termination][:contract_id] if params[:contract_termination]
  end

  def get_parent
    if contract_id
      @parent = Contract.find(contract_id)
    else
      @parent = ContractTermination.find(params[:id]).contract
    end
  end

  def block_contract_not_allowed
    raise Exceptions::Unauthorized unless @parent.allow_termination?
  end
end
