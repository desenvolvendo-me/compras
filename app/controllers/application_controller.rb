class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :handle_customer, :if => :production?
  before_filter :handle_action_mailer
  before_filter :authenticate_user!

  rescue_from CanCan::Unauthorized, :with => :unauthorized

  protected

  helper_method :current_prefecture

  def current_prefecture
    Prefecture.last
  end

  def authorize_resource!
    authorize! action_name, controller_name
  end

  def handle_customer(&block)
    customer = Customer.find_by_domain!(request.host)
    customer.using_connection(&block)
  end

  def production?
    Rails.env.production?
  end

  def handle_action_mailer
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def unauthorized
    if request.xhr?
      render :nothing => true, :status => :unauthorized
    else
      redirect_to '/401.html'
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
