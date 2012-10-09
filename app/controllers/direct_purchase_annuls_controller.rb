class DirectPurchaseAnnulsController < ResourceAnnulsController
  protected

  def create_resource(object)
    validate_parent!(object)

    object.transaction do
      object.save

      annul(object)
    end
  end

  def annul(object)
    direct_purchase = object.annullable

    DirectPurchaseAnnulment.new(direct_purchase, object, self).annul
  end
end
