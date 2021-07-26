class PurchaseProcessStatusChanger
  def initialize(purchase_process)
    @purchase_process = purchase_process
  end

  def in_progress!
    return if purchase_process.in_progress?

    if enabled_bidders?
      purchase_process.update_status(PurchaseProcessStatus::IN_PROGRESS)
    end
  end

  private

  attr_reader :purchase_process

  def enabled_bidders?
    purchase_process.bidders.enabled.any?
  end
end
