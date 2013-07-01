class PurchaseProcessProposalTiebreaksController < CrudController
  defaults resource_class: LicitationProcess, instance_name: :purchase_process

  def update
    update! do |success, failure|
      success.html { redirect_to purchase_process_proposals_path(licitation_process_id: resource.id) }
    end
  end
end
