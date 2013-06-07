class CreditorProposalBenefitedTiedsController < CrudController
  defaults resource_class: PurchaseProcessCreditorProposal

  def edit
    resource.old_unit_price = resource.unit_price
    resource.unit_price = nil
  end

  def update
    update! { edit_purchase_process_proposal_tiebreak_path(resource.licitation_process) }
  end

  private

  def update_resource(object, attributes)
    object.transaction do
      object.old_unit_price = object.unit_price
    end

    super
  end
end
