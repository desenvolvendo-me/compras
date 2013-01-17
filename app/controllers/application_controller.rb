class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_user

  around_filter :handle_customer, :if => :production?
  before_filter :handle_action_mailer
  before_filter :authenticate_user!

  rescue_from CanCan::Unauthorized, :with => :unauthorized
  rescue_from Exceptions::Unauthorized, :with => :unauthorized

  helper_method :current_prefecture, :root_url

  def current_prefecture
    Prefecture.last
  end

  def root_url
    "#{request.protocol}#{request.host_with_port}"
  end

  def render_to_pdf(partial_name, options = {})
    locals = options.fetch(:locals, {})
    stylesheets = options.fetch(:stylesheets, ["#{root_url}/assets/report.css"])

    pdf_instance = PDFKit.new render_to_string(:partial => partial_name, :locals => locals)

    if Rails.env.production? || Rails.env.staging?
      pdf_instance.stylesheets += stylesheets
    end

    pdf_instance.to_pdf
  end

  protected

  def layout_by_user
    if current_user && current_user.creditor?
      'creditor'
    else
      'application'
    end
  end

  def authorize_resource!
    authorize! action_name, controller_name
  end

  def handle_customer(&block)
    customer = Customer.find_by_domain!(request.headers['X-Customer'])
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
      if Rails.env.test?
        redirect_to '/401.html'
      else
        redirect_to '/compras/401.html'
      end
    end
  end
end
