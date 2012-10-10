class PurchaseSolicitationItemGroupProcess
  def initialize(process)
    @process = process
  end

  def set_item_group(purchase_solicitation_item_group)
    unless @process.purchase_solicitation_item_group.nil?
      change_status(@process.purchase_solicitation_item_group, pending_status)
    end

    @process.purchase_solicitation_item_group = purchase_solicitation_item_group
    @process.save!

    change_status(purchase_solicitation_item_group, in_purchase_status)
  end

  private

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
