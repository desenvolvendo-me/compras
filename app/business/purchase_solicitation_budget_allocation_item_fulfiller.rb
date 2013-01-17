class PurchaseSolicitationBudgetAllocationItemFulfiller
  def initialize(options = {})
    @purchase_solicitation_item_group = options[:purchase_solicitation_item_group]
    @direct_purchase = options[:direct_purchase]
    @administrative_process = options[:administrative_process]
    @add_fulfill = options[:add_fulfill]
  end

  def fulfill
    fulfill_items_from_item_group
    fulfill_items_from_direct_purchase
    fulfill_items_from_administrative_process
  end

  private

  attr_reader :purchase_solicitation_item_group, :direct_purchase, :add_fulfill,
              :administrative_process

  def fulfill_items_from_item_group
    return unless purchase_solicitation_item_group

    if add_fulfill
      process = direct_purchase || administrative_process
      purchase_solicitation_item_group.fulfill_items(process)
    else
      purchase_solicitation_item_group.fulfill_items(nil)
    end
  end

  def fulfill_items_from_direct_purchase
    return unless direct_purchase

    if add_fulfill
      direct_purchase.fulfill_purchase_solicitation_items
    else
      direct_purchase.remove_fulfill_purchase_solicitation_items
    end
  end

  def fulfill_items_from_administrative_process
    return unless administrative_process

    if add_fulfill
      administrative_process.fulfill_purchase_solicitation_items
    else
      administrative_process.remove_fulfill_purchase_solicitation_items
    end
  end
end
