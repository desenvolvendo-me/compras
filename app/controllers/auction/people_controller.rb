class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!
  before_filter :check_person_type, only: [:index, :new, :edit, :filter]

  layout "electronic_auction"

  def check
    company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

    render json: company
  end

  def create
    create! do |success, failure|
      if resource.personable_type == PersonableType::INDIVIDUAL
        success.html { redirect_to physical_peoples_path }
        @person_type = PersonableType::INDIVIDUAL
      else
        success.html { redirect_to legal_peoples_path }
        @person_type = PersonableType::COMPANY
      end
      failure.html { render "new" }
    end
  end

  def index
    company = Company.where(user_id: current_user.id).last
    if company
      redirect_to edit_auction_person_path(company.person.id)
    else
      super
    end
  end

  def new
    if current_user
      company = Company.where(user_id: current_user.id).last
      if company
        redirect_to edit_auction_person_path(company.person.id)
      else
        super
      end
    else
      person_type = Individual.new if params[:people]
      person_type = Company.new if params[:company]
      object = build_resource
      object.personable = person_type

      super
    end
  end

  def check_person_type
    if params[:filter] && params[:filter][:personable_type] == PersonableType::INDIVIDUAL || params[:by_physical_people] || params[:people]
      @person_type = PersonableType::INDIVIDUAL
    end
    if params[:filter] && params[:filter][:personable_type] == PersonableType::COMPANY || params[:by_legal_people] || params[:company]
      @person_type = PersonableType::COMPANY
    end
  end

  def create_resource(object)
    object.transaction do
      object.user_id = current_user.id
      object.personable_type = PersonableType::COMPANY
    end
  end
end
