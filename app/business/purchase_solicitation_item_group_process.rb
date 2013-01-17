class PurchaseSolicitationItemGroupProcess
  def initialize(options = {}, purchase_solicitation_status_changer = PurchaseSolicitationStatusChanger)
    @new_item_group = options[:new_item_group]
    @old_item_group = options[:old_item_group]
    @purchase_solicitation_status_changer = purchase_solicitation_status_changer
  end

  def update_status
    return unless new_item_group != old_item_group

    validate_pending_status
    update_old_item_group_status
    update_new_item_group_status
  end

  private

  attr_reader :new_item_group, :old_item_group, :purchase_solicitation_status_changer

  def update_new_item_group_status
    return if new_item_group.nil?

    new_item_group.change_status!(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
    new_item_group.purchase_solicitations.each do |purchase_solicitation|
      purchase_solicitation_status_changer.change(purchase_solicitation)
    end
  end

  def update_old_item_group_status
    return if old_item_group.nil?

    old_item_group.change_status!(PurchaseSolicitationItemGroupStatus::PENDING)
    old_item_group.purchase_solicitations.each do |purchase_solicitation|
      purchase_solicitation_status_changer.change(purchase_solicitation)
    end
  end

  def validate_pending_status
    return if new_item_group.nil?

    raise ArgumentError, "Item group status should be 'Pending'" unless new_item_group.pending?
  end
end
