module Auction::ProposalsHelper
  def creditor_proposals_collection
    return nil unless @current_user.creditor?

    proposals = resource.proposals_of_creditor(@current_user.authenticable)
    proposals = nil if proposals.empty?

    proposals || PurchaseProcessCreditorProposalBuilder.build_proposals(resource, @current_user.authenticable)
  end

  def form_partial
    "form_#{resource.judgment_form_kind}"
  end

  def new_title
    base = I18n.t("#{controller_name}.new", :resource => singular, :cascade => true)

    base + " - Pregão #{resource.auction.to_s}"
  end

  def edit_title
    "Proposta de Registro de Preço - Pregão #{resource.auction.to_s}"
  end
end
