class SupplyAuthorizationGenerator
  attr_accessor :direct_purchase_object, :supply_authorization_storage

  def initialize(direct_purchase_object, supply_authorization_storage = SupplyAuthorization)
    self.direct_purchase_object = direct_purchase_object
    self.supply_authorization_storage = supply_authorization_storage
  end

  def generate!
    if direct_purchase_object.authorized?
      direct_purchase_object.supply_authorization
    else
      authorize!
    end
  end

  def authorize!
    supply_authorization_storage.create!(
      :direct_purchase_id => direct_purchase_object.id,
      :year => direct_purchase_object.year,
    )
  end
end
