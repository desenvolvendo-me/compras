class BidderDisqualificationsController < CrudController
  actions :all, :except => [:index, :filter, :modal]

  before_filter :trading_item
  before_filter :deny_bidders_not_allowed, :only => [:new, :create]

  def new
    object = build_resource
    object.bidder_id = bidder.id
    object.created_at = DateTime.current

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to classification_trading_item_path(@trading_item) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to classification_trading_item_path(@trading_item) }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { redirect_to classification_trading_item_path(@trading_item) }
    end
  end

  protected

  def main_controller_name
    'tradings'
  end

  def trading_item
    @trading_item = TradingItem.find(params[:trading_item_id])
  end

  def bidder
    Bidder.find(bidder_id)
  end

  def bidder_id
    params[:bidder_id] || params[:bidder_disqualification][:bidder_id]
  end

  def deny_bidders_not_allowed
     return if bidder_valid?

     raise ActiveRecord::RecordNotFound
  end

  def bidder_valid?
    @trading_item.bidders.include?(bidder) && bidder.can_be_disabled?(@trading_item)
  end
end
