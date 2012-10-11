#encoding: utf-8
module PriceCollectionProposalsHelper
  def proposals_list_header(parent)
    title = PriceCollectionProposal.model_name.human(:count => 'many')
    title = "Propostas para a Coleta #{parent}" if parent
    content_tag :h2, title
  end

  def proposal_back_button(form)
    if current_user.creditor?
      form.button :back
    else
      form.button :back, :href => edit_price_collection_path(resource.price_collection)
    end
  end
end
