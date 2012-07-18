class SupplyAuthorizationGenerator
  attr_accessor :direct_purchase_object, :supply_authorization_repository

  def initialize(direct_purchase_object, supply_authorization_repository = SupplyAuthorization)
    self.direct_purchase_object = direct_purchase_object
    self.supply_authorization_repository = supply_authorization_repository
  end

  def generate!
    if direct_purchase_object.authorized?
      direct_purchase_object.supply_authorization
    else
      authorize!
    end
  end

  def authorize!
    supply_authorization_repository.create!(
      :direct_purchase_id => direct_purchase_object.id,
      :year => direct_purchase_object.year,
    )
  end
end
