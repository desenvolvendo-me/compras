class TradingClosingsController < CrudController
  actions :new, :create

  before_filter :parent

  def new
    object = build_resource

    object.trading = parent

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to trading_item_procedures_path }
    end
  end

  private

  def main_controller_name
    'tradings'
  end

  def parent
    @parent ||= parent_from_params_or_resource
  end

  def parent_id
    return unless params[:trading_id] || params[:trading_closing]

    params[:trading_id] || params[:trading_closing][:trading_id]
  end

  def parent_from_params_or_resource
    if params[:id]
      TradingClosing.find(params[:id]).trading
    elsif parent_id
      Trading.find(parent_id)
    end
  end

  def trading_item_procedures_path
    edit_trading_path(parent, :anchor => :procedures)
  end
end
