class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!
  layout "electronic_auction"

  def check
    company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

    render json: company
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
      person_type = Individual.new if params[:by_physical_people]
      person_type = Company.new if params[:by_legal_people]
      object = build_resource
      object.personable = person_type

      super
    end
  end

  def create_resource(object)
    object.transaction do
      object.user_id = current_user.id
    end
  end
end
