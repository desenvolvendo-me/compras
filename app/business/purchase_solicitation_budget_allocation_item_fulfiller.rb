class PurchaseSolicitationBudgetAllocationItemFulfiller
  def initialize(options = {})
    @direct_purchase = options[:direct_purchase]
    @licitation_process = options[:licitation_process]
    @add_fulfill = options[:add_fulfill]
  end

  def fulfill
    fulfill_items_from_direct_purchase
    fulfill_items_from_licitation_process
  end

  private

  attr_reader :direct_purchase, :add_fulfill, :licitation_process

  def fulfill_items_from_direct_purchase
    return unless direct_purchase

    if add_fulfill
      direct_purchase.fulfill_purchase_solicitation_items
    else
      direct_purchase.remove_fulfill_purchase_solicitation_items
    end
  end

  def fulfill_items_from_licitation_process
    return unless licitation_process

    if add_fulfill
      licitation_process.fulfill_purchase_solicitation_items
    else
      licitation_process.remove_fulfill_purchase_solicitation_items
    end
  end
end
