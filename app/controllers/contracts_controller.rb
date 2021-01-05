class ContractsController < CrudController
  has_scope :founded, :type => :boolean
  has_scope :management, :type => :boolean
  has_scope :purchase_process_id, allow_blank: true
  has_scope :between_days_finish, using: %i[started_at ended_at], :type => :hash
  has_scope :by_days_finish, allow_blank: true
  has_scope :by_licitation_process, allow_blank: true
  has_scope :by_creditor_principal_contracts, allow_blank: true
  has_scope :by_years, type: :boolean, default: true, only: [:index]

  layout "report", only: [:conference]

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

    render :json => {creditor: contract.creditor.person.name, balance: balance, value: contract.contract_value}
  end

  def conference
    @contract = Contract.find(params[:contract_id])

    respond_to do |format|
      format.html
      format.xlsx do
        path = ConferenceXlsxGenerator.new(@contract).generate!
        send_file path, type: "application/xlsx", :filename => "contrato.xlsx"
      end
    end
  end

  protected

  def create_resource(object)
    object.sequential_number = Contract.next_sequential(object.year)

    super
  end
end
