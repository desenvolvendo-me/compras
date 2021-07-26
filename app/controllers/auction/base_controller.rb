class Auction::BaseController < CrudController
  before_filter :authorize_resource!

  def authorize_resource!
    authorize! action_name, auction_controller_name
  end


  def main_controller_name
    MainControllerGetter.new(auction_controller_name).name
  end

  def auction_controller_name
    "auction_#{controller_name}"
  end

end
