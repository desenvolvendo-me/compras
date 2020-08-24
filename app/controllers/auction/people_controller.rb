class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!
  layout "electronic_auction"

  def check
    company = Company.find_by_cnpj(params[:cnpj]) if params[:cnpj].present?

    render json: company
  end
end
