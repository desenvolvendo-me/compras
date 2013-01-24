class TradingItemClosingsController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :trading_item
  before_filter :not_allow_create_an_already_closed_trading_item, :only => [:new, :create]

  def new
    object = build_resource
    object.trading_item_id = trading_item.id
    object.bidder = trading_item.bidder_with_lowest_proposal

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to resource.decorator.after_create_path }
    end
  end

  protected

  def main_controller_name
    'tradings'
  end

  def create_resource(object)
    object.transaction do
      object.bidder = trading_item.bidder_with_lowest_proposal

      super
    end
  end

  def trading_item
    @trading_item ||= if params[:id]
      resource.trading_item
    else
      TradingItem.find(trading_item_id)
    end
  end

  def trading_item_id
    params[:trading_item_id] || params[:trading_item_closing][:trading_item_id]
  end

  def not_allow_create_an_already_closed_trading_item
    return unless trading_item.closed?

    raise ActiveRecord::RecordNotFound
  end
end
