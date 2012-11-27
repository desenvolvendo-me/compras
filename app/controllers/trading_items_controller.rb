class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]
  custom_actions :resource => [:classification, :proposal_report]

  def update
    update!{ trading_items_path(:trading_id => @parent.id) }
  end

  protected

  def authorize_resource!
    if action_name == 'classification' || action_name == 'proposal_report'
      authorize! :read, controller_name
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
