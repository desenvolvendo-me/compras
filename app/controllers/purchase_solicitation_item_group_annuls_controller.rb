class PurchaseSolicitationItemGroupAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
    purchase_solicitation_item_group = object.annullable

    PurchaseSolicitationItemGroupAnnulment.new(purchase_solicitation_item_group).annul
  end

  def validate_parent!(object)
    raise Exceptions::Unauthorized unless object.annullable.annullable?

    super
  end
end
