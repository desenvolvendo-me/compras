class PurchaseSolicitationAnnulsController < ResourceAnnulsController
  before_filter :deny_annul_with_direct_purchase, :only => [:new, :create]

  private

  def deny_annul_with_direct_purchase
    purchase_solicitation = PurchaseSolicitation.find(purchase_solicitation_id)

    raise Exceptions::Unauthorized if purchase_solicitation.direct_purchase.present?
  end

  def purchase_solicitation_id
    params[:annullable_id] || params[:resource_annul][:annullable_id]
  end
end
