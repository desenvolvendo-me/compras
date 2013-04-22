class PurchaseProcessStatusChanger
  def initialize(purchase_process)
    @purchase_process = purchase_process
  end

  def in_progress!
    return if @purchase_process.in_progress?

    @purchase_process.update_status(PurchaseProcessStatus::IN_PROGRESS)
  end

  private

  attr_reader :purchase_process
end
