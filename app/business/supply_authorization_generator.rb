class SupplyAuthorizationGenerator
  def initialize(direct_purchase_object, supply_authorization_repository = SupplyAuthorization, item_repository = PurchaseSolicitationBudgetAllocationItem, item_group_status_changer = PurchaseSolicitationItemGroupStatusChanger)
    @direct_purchase_object = direct_purchase_object
    @supply_authorization_repository = supply_authorization_repository
    @item_repository = item_repository
    @item_group_status_changer = item_group_status_changer
  end

  def generate!
    if direct_purchase_object.authorized?
      direct_purchase_object.supply_authorization
    else
      attend_items_purchase_solicitation
      attend_purchase_solicitation
      attend_items_purchase_solicitation_item_group
      attend_purchase_solicitation_item_group
      authorize!
    end
  end

  private

  attr_reader :direct_purchase_object, :supply_authorization_repository,
              :item_repository, :item_group_status_changer

  delegate :purchase_solicitation, :purchase_solicitation_item_group,
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

  def attend_items_purchase_solicitation_item_group
    return if purchase_solicitation_item_group.blank?

    item_repository.by_item_group(purchase_solicitation_item_group).attend!
  end

  def attend_purchase_solicitation_item_group
    return if purchase_solicitation_item_group.blank?

    item_group_status_changer.change(purchase_solicitation_item_group)
  end
end
