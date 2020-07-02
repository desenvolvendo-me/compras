class Auction::BaseController < CrudController
  before_filter :authorize_resource!

  def authorize_resource!
    authorize! action_name, "auction_#{controller_name}"
  end
end
