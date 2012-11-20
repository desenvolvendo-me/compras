class DirectPurchaseAnnulsController < ResourceAnnulsController
  protected

  def create_resource(object)
    validate_parent!(object)

    object.transaction do
      object.save

      annul(object)

      direct_purchase = object.annullable
      PurchaseSolicitationLiberate.new(direct_purchase.purchase_solicitation).liberate!
    end
  end

  def annul(object)
    direct_purchase = object.annullable

    DirectPurchaseAnnulment.new(
      :direct_purchase => direct_purchase,
      :resource_annul => object,
      :context => self
    ).annul
  end
end
