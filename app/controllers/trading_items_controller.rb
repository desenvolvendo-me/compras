class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]

  protected

  def begin_of_association_chain
    if params[:trading_id]
      @parent = Trading.find(params[:trading_id])
    end
  end
end
