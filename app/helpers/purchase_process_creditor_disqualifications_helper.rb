module PurchaseProcessCreditorDisqualificationsHelper
  def new_title
    "Desclassificar fornecedor #{resource.creditor} - Processo #{resource.licitation_process}"
  end

  def edit_title
    new_title
  end

  def check_proposal_item?(proposal_item)
    proposal_item_ids = params[:proposal_item_ids] || []
    proposal_item_ids.include?(proposal_item.id.to_s) || proposal_item.disqualified?
  end
end
