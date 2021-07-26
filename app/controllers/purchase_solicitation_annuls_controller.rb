class PurchaseSolicitationAnnulsController < ResourceAnnulsController
  before_filter :deny_annul_with_purchase_process, :only => [:new, :create]

  private

  def deny_annul_with_purchase_process
    purchase_solicitation = PurchaseSolicitation.find(purchase_solicitation_id)

    raise Exceptions::Unauthorized if purchase_solicitation.licitation_processes.any?
  end

  def purchase_solicitation_id
    params[:annullable_id] || params[:resource_annul][:annullable_id]
  end
end
