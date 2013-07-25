module Api
  class Controller < ApplicationController
    skip_before_filter :authenticate_user!, :verify_authenticity_token
    before_filter :authenticate_customer!

    respond_to :json

    rescue_from Exception, :with => :internal_server_error
    rescue_from ActionController::ParameterMissing, :with => :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

    has_scope :filter, :type => :hash

    protected

    def authenticate_customer!
      unauthorized("Invalid authentication token") unless api_customer_token and current_customer
    end

    def current_customer
      @current_customer ||= Customer.find_by_secret_token!(api_customer_token)
    end
    helper_method :current_customer

    private

    # 400
    def bad_request(message = nil, json = {})
      render :status => :bad_request,
             :json   => json.merge(:message => message)
    end

    def parameter_missing(exception)
      bad_request "Missing parameter", :parameter => exception.param
    end

    # 401
    def unauthorized(message = nil)
      render :status => :unauthorized,
             :json   => { :message => message }
    end

    # 403
    def forbidden(message = "Permission denied")
      render :status => :forbidden,
             :json   => { :message => message }
    end

    # 404
    def record_not_found(exception)
      render :status => :not_found,
             :json   => { :message => "Record not found" }
    end

    # 422
    def unprocessable_entity(resource)
      render :status => :unprocessable_entity,
             :json => { errors: resource.errors.full_messages }
    end

    # 500
    def internal_server_error(exception)
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        render :status => :internal_server_error,
               :json   => { :message => "Internal server error" }
      end
    end

    def api_customer_token
      request.headers["x-unico-api-customer-secret-token"]
    end
  end
end
