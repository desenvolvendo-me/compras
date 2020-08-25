class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!
  layout "electronic_auction"

  def check
    company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

    render json: company
  end

  def new
    if current_user
      company = Company.where(user_id: current_user.id).last
      redirect_to edit_company_path(company.id) if company
    end
    super
  end
end
