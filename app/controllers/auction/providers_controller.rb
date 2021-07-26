class Auction::ProvidersController < Auction::BaseController
  skip_before_filter :authenticate_user!, :only => [:register_external, :check_register_external, :new, :create]
  skip_before_filter :authorize_resource!, :only => [:register_external, :check_register_external, :new, :create]
  before_filter :set_company
  layout "electronic_auction"

  defaults resource_class: User

  def create
    create! { new_user_session_path }
  end

  def new
    redirect_to auctions_external_index_path, :alert => 'Houve um erro contate suporte.' unless @company
    object = build_resource
    object.authenticable = @company.person.creditor
  end

  def register_external
  end

  def check_register_external
    user = User.where(authenticable_id: @company&.person&.creditor&.id, authenticable_type: AuthenticableType::CREDITOR).first

    if user
      redirect_to new_user_session_path, :notice => "Sua empresa já está cadastrada. Agora faça o login."
    elsif @company.blank?
      redirect_to new_auction_creditor_path(cnpj: params[:cnpj]), :alert => "Sua empresa não está cadastrada. Faça o cadastro."
    else
      redirect_to new_auction_provider_path(company_id: @company.id), :alert => "Sua empresa já esta cadastra. Finalize o cadastro do login."
    end
  end

  protected

  def set_company
    @company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?
    @company = Company.find(params[:company_id]) if params[:company_id]
  end

  def create_resource(object)
    object.profile_id = Profile.where(name: 'Pregão').last.id
    object.activated = true
    object.electronic_auction = true
    object.skip_confirmation!

    super
  end
end
