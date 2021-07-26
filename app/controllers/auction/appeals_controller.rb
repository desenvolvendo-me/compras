class Auction::AppealsController <  Auction::BaseController
  defaults resource_class: AuctionAppeal

  def new
    object = build_resource
    object.auction_id = params[:auction_id]
    object.person = current_user.authenticable.try(:person)

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :edit }
    end
  end

  def mark_viewed
    @appeal = AuctionAppeal.find(params[:auction_appeal_id])
    @appeal.mark_as_viewed

    redirect_to edit_auction_appeal_path(@appeal)

  end
end
