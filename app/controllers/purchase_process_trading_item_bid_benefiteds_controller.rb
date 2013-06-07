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
    if TradingItemBidBenefitedCreator.create(object).save
      TradingItemStatusChanger.change(object.item)

      true
    end
  end

  def item
    @item ||= PurchaseProcessTradingItem.find item_id
  end

  def item_id
    return unless params[:item_id] || params[:purchase_process_trading_item_bid]

    params[:item_id] || params[:purchase_process_trading_item_bid][:item_id]
  end

  def winner_is_benefited
    if item.last_bid_with_proposal.blank? || item.last_bid_with_proposal.accreditation_creditor.benefited?
      redirect_to bids_purchase_process_trading_path(item.trading)
    end
  end
end
