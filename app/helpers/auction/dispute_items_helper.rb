module Auction::DisputeItemsHelper
  def edit_title
    ''
  end

  def new_title
  end

  def check_status_my_bids dispute_item
    return unless current_user.creditor?
    #Todo adicionar opção para empate depois que definir regras

    if dispute_item.bids.last&.creditor&.id == current_user.authenticable.id
      "<span class='material-icons text-sucess'>thumb_up</span>".html_safe
    else
      "<span class='material-icons text-danger'>thumb_down</span>".html_safe
    end
  end
end