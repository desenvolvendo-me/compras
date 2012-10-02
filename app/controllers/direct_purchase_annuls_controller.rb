class DirectPurchaseAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
    direct_purchase = object.annullable

    object.transaction do
      DirectPurchaseAnnulment.new(direct_purchase, object).annul
    end
  end
end
