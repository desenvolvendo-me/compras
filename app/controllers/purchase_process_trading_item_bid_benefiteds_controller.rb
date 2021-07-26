class PurchaseProcessTradingItemBidBenefitedsController < CrudController
  defaults resource_class: PurchaseProcessTradingItemBid

  actions :new, :create

  before_filter :winner_is_benefited

  def new
    object = build_resource
    object.item = item

    super
  end

  def create
    create! do |success, failure|
      success.html do
        redirect_to bids_purchase_process_trading_path(item.trading)
      end
    end
  end

  private

  def create_resource(object)
    TradingItemBidBenefitedCreator.create(object).save
  end

  def item
    @item ||= PurchaseProcessTradingItem.find item_id
  end

  def item_id
    return unless params[:item_id] || params[:purchase_process_trading_item_bid]

    params[:item_id] || params[:purchase_process_trading_item_bid][:item_id]
  end

  def winner_is_benefited
    if !item.closed? || !item.benefited_tie?
      redirect_to bids_purchase_process_trading_path(item.trading)
    end
  end
end
