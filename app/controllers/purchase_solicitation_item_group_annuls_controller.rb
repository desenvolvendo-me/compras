class PurchaseSolicitationItemGroupAnnulsController < ResourceAnnulsController
  protected

  def annul(object)
  end

  def validate_parent!(object)
    raise Exceptions::Unauthorized unless object.annullable.annullable?

    super
  end
end
