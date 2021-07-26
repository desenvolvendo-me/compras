module Api
  class ContractsController < Controller
    has_scope :by_signature_period, using: [:started_at, :ended_at]

    #GET /api/contracts
    def index
      contracts = apply_scopes(Contract).limit(params[:limit]).offset(params[:offset]).all

      render :json => ContractProvider.build_array(contracts)
    end

    #GET /api/contract/:id
    def show
      contract = Contract.find(params[:id])

      render json: ContractProvider.new(contract)
    end
  end
end
