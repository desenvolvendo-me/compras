module Api
  class ContractsController < Controller
    #GET /api/contracts
    def index
      contracts = apply_scopes(Contract).all

      render json: contracts
    end

    #GET /api/contract/:id
    def show
      contract = Contract.find(params[:id])

      render json: contract
    end
  end
end
