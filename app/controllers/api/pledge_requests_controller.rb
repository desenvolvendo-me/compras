module Api
  class PledgeRequestsController < Controller
    def index
      pledge_requests = apply_scopes(PledgeRequest).all

      render :json => pledge_requests.to_json(include: params[:include], methods: params[:methods])
    end

    def show
      pledge_request = PledgeRequest.find(params[:id])

      render :json => pledge_request.to_json(include: params[:include], methods: params[:methods])
    end

    def update
      pledge_request = PledgeRequest.find(params[:id])

      if pledge_request.update_attributes(params[:pledge_request])
        render :json => pledge_request
      else
        unprocessable_entity(pledge_request)
      end
    end
  end
end
