class Auction::SuspensionsController <  Auction::BaseController
  defaults resource_class: AuctionSuspension

  defaults :route_prefix => 'auction_auction'

  def new
    object = build_resource
    object.auction_id = params[:auction_id]
    object.responsible_suspension = current_user

    super
  end

  def edit
    object = resource
    object.responsible_reactivation_id = current_user.id

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_auction_auction_suspension_path(resource.auction_id, resource.id) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_auction_auction_suspension_path(resource.auction_id, resource.id) }
    end
  end
end
