class SupplyAuthorizationGenerator
  attr_accessor :direct_purchase_object, :supply_authorization_repository

  delegate :purchase_solicitation,
           :to => :direct_purchase_object, :allow_nil => true

  def initialize(direct_purchase_object, supply_authorization_repository = SupplyAuthorization)
    self.direct_purchase_object = direct_purchase_object
    self.supply_authorization_repository = supply_authorization_repository
  end

  def generate!
    if direct_purchase_object.authorized?
      direct_purchase_object.supply_authorization
    else
      attend_purchase_solicitation
      direct_purchase_object.fulfill_item_group
      authorize!
    end
  end

  private

  def authorize!
    supply_authorization_repository.create!(
      :direct_purchase_id => direct_purchase_object.id,
      :year => direct_purchase_object.year,
    )
  end

  def attend_purchase_solicitation
    return unless purchase_solicitation.present?

    purchase_solicitation.attend!
  end
end
