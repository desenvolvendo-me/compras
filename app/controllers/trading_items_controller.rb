class TradingItemsController < CrudController
  actions :all, :except => [:new, :create, :destroy]
  custom_actions :resource => [:offers, :proposal_report]

  def update
    update!{ trading_items_path(:trading_id => @parent.id) }
  end

  def activate_proposals
    resource.transaction do
      resource.activate_proposals!
    end

    redirect_to classification_trading_item_path(resource)
  end

  def classification
    if resource.proposals_activated?
      render 'classification_for_activated_proposals'
    end
  end

  protected

  def main_controller_name
    'tradings'
  end

  def authorize_resource!

    if action_name == 'classification' || action_name == 'proposal_report' || action_name == 'offers'
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
