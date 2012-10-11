class PurchaseSolicitationItemGroupProcess
  def initialize(process)
    @process = process
  end

  def update_item_group_status(purchase_solicitation_item_group)
    validate_pending_status(purchase_solicitation_item_group)

    unless @process.purchase_solicitation_item_group.nil?
      change_status(@process.purchase_solicitation_item_group, pending_status)
    end

    change_status(purchase_solicitation_item_group, in_purchase_status)
  end

  private

  def validate_pending_status(item_group)
    raise ArgumentError, "Item group status should be 'Pending'" unless item_group.pending?
  end

  def change_status(item_group, status)
    item_group.change_status!(status)
  end

  def in_purchase_status
    PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS
  end

  def pending_status
    PurchaseSolicitationItemGroupStatus::PENDING
  end
end
