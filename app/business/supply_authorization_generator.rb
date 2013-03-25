class SupplyAuthorizationGenerator
  def initialize(direct_purchase_object, supply_authorization_repository = SupplyAuthorization)
    @direct_purchase_object = direct_purchase_object
    @supply_authorization_repository = supply_authorization_repository
  end

  def generate!
    if direct_purchase_object.authorized?
      direct_purchase_object.supply_authorization
    else
      attend_items_purchase_solicitation
      attend_purchase_solicitation
      authorize!
    end
  end

  private

  attr_reader :direct_purchase_object, :supply_authorization_repository

  delegate :purchase_solicitation,
           :to => :direct_purchase_object, :allow_nil => true

  def authorize!
    supply_authorization_repository.create!(
      :direct_purchase_id => direct_purchase_object.id,
      :year => direct_purchase_object.year,
    )
  end

  def attend_items_purchase_solicitation
    return if purchase_solicitation.blank?

    purchase_solicitation.attend_items!
  end

  def attend_purchase_solicitation
    return if purchase_solicitation.blank?

    purchase_solicitation.attend!
  end
end
