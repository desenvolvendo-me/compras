module Api
  class PurchaseProcessesController < Controller
    # GET /api/purchase_processes
    def index
      purchase_processes = apply_scopes(LicitationProcess).all

      render json: purchase_processes
    end

    # GET /api/purchase_process/:id
    def show
      purchase_process = LicitationProcess.find(params[:id])

      render json: purchase_process
    end
  end
end
