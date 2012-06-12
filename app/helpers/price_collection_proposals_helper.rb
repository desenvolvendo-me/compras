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
      link_to "Anular", new_price_collection_proposal_price_collection_proposal_annul_path(resource), :class => 'button primary'
    elsif resource.annulled?
      link_to "Anulação", edit_price_collection_proposal_price_collection_proposal_annul_path(resource), :class => 'button primary'
    end
  end

  def proposal_cancel_button(form)
    if current_user.provider?
      form.button :cancel
    else
      form.button :cancel, :href => edit_price_collection_path(resource.price_collection)
    end
  end
end
