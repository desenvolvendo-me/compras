class PurchaseSolicitationItemGroupProcess
  def initialize(options = {})
    @new_item_group = options.fetch(:new_item_group, nil)
    @old_item_group = options.fetch(:old_item_group, nil)
  end

  def update_status
    return unless new_item_group != old_item_group

    validate_pending_status
    update_old_item_group_status
    update_new_item_group_status
  end

  private

  attr_reader :new_item_group, :old_item_group

  def update_new_item_group_status
    return if new_item_group.nil?

    new_item_group.change_status!(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
    new_item_group.buy_purchase_solicitations!
  end

  def update_old_item_group_status
    return if old_item_group.nil?

    old_item_group.change_status!(PurchaseSolicitationItemGroupStatus::PENDING)
    old_item_group.liberate_purchase_solicitations!
  end

  def validate_pending_status
    return if new_item_group.nil?

    raise ArgumentError, "Item group status should be 'Pending'" unless new_item_group.pending?
  end
end
