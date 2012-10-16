class PurchaseSolicitationItemGroupProcess
  def self.update_item_group_status(old_item_group, new_item_group)
    validate_pending_status(new_item_group)

    change_status(old_item_group, PurchaseSolicitationItemGroupStatus::PENDING)
    change_status(new_item_group, PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
  end

  private

  def self.validate_pending_status(item_group)
    return if item_group.nil?

    raise ArgumentError, "Item group status should be 'Pending'" unless item_group.pending?
  end

  def self.change_status(item_group, status)
    return if item_group.nil?

    item_group.change_status!(status)
  end
end
