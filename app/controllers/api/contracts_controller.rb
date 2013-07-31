module Api
  class ContractsController < Controller
    has_scope :by_signature_period, using: [:started_at, :ended_at]

    #GET /api/contracts
    def index
      contracts = apply_scopes(Contract).all

      render :json => contracts.to_json(include: params[:includes], methods: params[:methods])
    end

    #GET /api/contract/:id
    def show
      contract = Contract.find(params[:id])

      render json: contract
    end
  end
end
