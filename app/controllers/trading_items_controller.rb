class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]

  def update
    update!{ trading_items_path(:trading_id => @parent.id) }
  end

  protected

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
