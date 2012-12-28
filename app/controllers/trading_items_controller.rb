class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]
  custom_actions :resource => [:classification, :offers, :proposal_report, :close]

  def update
    update!{ trading_items_path(:trading_id => @parent.id) }
  end

  def close
    trading_item = TradingItem.find(params[:id])
    trading_item.close!
    redirect_to trading_items_path(:trading_id => trading_item.trading_id)
  end

  protected

  def main_controller_name
    'tradings'
  end

  def authorize_resource!

    if action_name == 'classification' || action_name == 'proposal_report' || action_name == 'close' || action_name == 'offers'
      authorize! :read, main_controller_name
    else
      super
    end
  end

  def begin_of_association_chain
    @parent = parent
  end

  def parent
    if params[:trading_id]
      Trading.find(params[:trading_id])
    elsif params[:id]
      TradingItem.find(params[:id]).trading
    end
  end
end
