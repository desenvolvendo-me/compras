class Auction::ProvidersController < Auction::BaseController
  skip_before_filter :authenticate_user!, :only => [:register_external, :check_register_external, :new, :create]
  skip_before_filter :authorize_resource!, :only => [:register_external, :check_register_external, :new, :create]
  layout "electronic_auction"

  defaults resource_class: User

  def create
    create! { new_user_session_path }
  end

  def new
    if params[:cnpj].present?
      company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

      render json: company
    else
      super
    end
  end

  def register_external
  end

  def check_register_external
    company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

    if company
      redirect_to new_user_session_path, :notice => "Sua empresa já está cadastrada. Agora faça o login."
    else
      redirect_to new_auction_provider_path, :alert => "Sua empresa não está cadastrada. Faça o cadastro."
    end
  end

  protected

  def create_resource(object)
    object.profile_id = Profile.where(name: "Pregão").last.id
    object.activated = true
    object.electronic_auction = true
    object.authenticable_type = "Provider"
    object.skip_confirmation!

    super
  end
end
