#encoding: utf-8
module PriceCollectionProposalsHelper
  def proposals_list_header(parent)
    title = PriceCollectionProposal.model_name.human(:count => 'many')
    title = "Propostas para a Coleta #{parent}" if parent
    content_tag :h2, title
  end

  def proposal_annul_link
    return unless can? :modify, :price_collection_proposal_annuls

    if resource.active?
      link_to "Anular", new_price_collection_proposal_annul_path(:price_collection_proposal_id => resource.id), :class => 'button negative'
    elsif resource.annulled?
      link_to "Anulação", edit_price_collection_proposal_annul_path(resource.annul), :class => 'button negative'
    end
  end

  def proposal_cancel_button(form)
    if current_user.creditor?
      form.button :cancel
    else
      form.button :cancel, :href => edit_price_collection_path(resource.price_collection)
    end
  end
end
