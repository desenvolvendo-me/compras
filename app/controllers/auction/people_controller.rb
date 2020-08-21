class Auction::PeopleController < Auction::BaseController
  skip_before_filter :authenticate_user!
  skip_before_filter :authorize_resource!

  def authorize_resource!
    authorize! action_name, auction_controller_name
  end
end
