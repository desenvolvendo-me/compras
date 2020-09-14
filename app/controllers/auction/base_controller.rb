class Auction::BaseController < CrudController
  before_filter :authorize_resource!
  before_filter :check_current_user_register

  def authorize_resource!
    authorize! action_name, auction_controller_name
  end

  def check_current_user_register
    if current_user.try(:provider?) && current_user.try(:authenticable_id).blank?
      if auction_controller_name != 'auction_creditors'
        flash[:alert] = "Por favor finalize o seu cadastro inserindo as informações abaixo."
        redirect_to new_auction_creditor_path
      end
    end
  end

  def main_controller_name
    MainControllerGetter.new(auction_controller_name).name
  end

  def auction_controller_name
    "auction_#{controller_name}"
  end

end
