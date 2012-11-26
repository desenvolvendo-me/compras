class DirectPurchaseAnnulsController < ResourceAnnulsController

  def create
    object = build_resource
    create!(:notice => success_notice(object) ) { edit_parent_path }
  end

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

  private

  def success_notice(object)
    I18n.t('compras.messages.direct_purchase_annulled_successfully', :direct_purchase => object.annullable)
  end
end
