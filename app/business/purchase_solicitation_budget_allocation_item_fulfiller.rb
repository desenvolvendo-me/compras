class PurchaseSolicitationBudgetAllocationItemFulfiller
  def initialize(options = {}, process = nil)
    @purchase_solicitation_item_group = options.fetch(:purchase_solicitation_item_group, nil)
    @direct_purchase = options.fetch(:direct_purchase, nil)
    @administrative_process = options.fetch(:administrative_process, nil)
    @process = process
  end

  def fulfill
    fulfill_items_from_item_group
    fulfill_items_from_direct_purchase
    fulfill_items_from_administrative_process
  end

  private

  attr_reader :purchase_solicitation_item_group, :direct_purchase, :process,
              :administrative_process

  def fulfill_items_from_item_group
    return unless purchase_solicitation_item_group

    purchase_solicitation_item_group.fulfill_items(process)
  end

  def fulfill_items_from_direct_purchase
    return unless direct_purchase

    direct_purchase.fulfill_purchase_solicitation_items(process)
  end

  def fulfill_items_from_administrative_process
    return unless administrative_process

    administrative_process.fulfill_purchase_solicitation_items(process)
  end
end
