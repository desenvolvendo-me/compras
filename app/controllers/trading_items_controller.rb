class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]

  def update
    update!{ trading_items_path(:trading_id => @parent.id) }
  end

  protected

  def begin_of_association_chain
    @parent = get_parent
  end

  def get_parent
    if params[:id]
      TradingItem.find(params[:id]).trading
    elsif params[:trading_id]
      Trading.find(params[:trading_id])
    end
  end
end
