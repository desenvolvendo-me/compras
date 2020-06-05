class ContractsController < CrudController
  has_scope :founded, :type => :boolean
  has_scope :management, :type => :boolean
  has_scope :purchase_process_id, allow_blank: true

  def new
    object = build_resource
    object.year = Date.current.year

    super
  end

  def next_sequential
    render :nothing => true and return if params[:year].blank?

    respond_to do |format|
      format.json do
        render :json => {:sequential => Contract.next_sequential(params[:year])}
      end
    end
  end

  def plegde_request
    contract = Contract.find(params["contract_id"])

    plegde_request_total = PledgeRequest.where(contract_id: params["contract_id"]).sum(:amount)

    balance = contract.contract_value - plegde_request_total

    render :json => {creditor: contract.creditors.first.person.name, balance: balance, value: contract.contract_value}
  end

  def conference
  end

  protected

  def default_filters
    {:year => lambda {Date.current.year}}
  end

  def create_resource(object)
    object.sequential_number = Contract.next_sequential(object.year)

    super
  end
end
