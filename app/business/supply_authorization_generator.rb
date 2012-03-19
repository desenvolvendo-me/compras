class SupplyAuthorizationGenerator
  attr_accessor :direct_purchase_object, :supply_authorization_storage

  def initialize(direct_purchase_object, supply_authorization_storage = SupplyAuthorization)
    self.direct_purchase_object = direct_purchase_object
    self.supply_authorization_storage = supply_authorization_storage
  end

  def generate!
    return direct_purchase_object.supply_authorization if direct_purchase_object.authorized?

    return authorize!
  end

  def authorize!
    supply_authorization = supply_authorization_storage.create(
      :direct_purchase_id => direct_purchase_object.id,
      :year => direct_purchase_object.year,
    )
    return supply_authorization
  end
end
