class PurchaseSolicitationProcess
  attr_reader :process, :purchase_solicitation

  def initialize(process, options = {})
    @process = process
    @in_process_status = options[:in_process_status]
    @pending_status = options[:pending_status]
  end

  def set_solicitation(solicitation)
    unless process.purchase_solicitation.nil?
      change_solicitation_status(process.purchase_solicitation, pending_status)
    end

    process.purchase_solicitation = solicitation
    process.save!
    change_solicitation_status(solicitation, in_process_status)
  end

  private

  def change_solicitation_status(purchase_solicitation, status)
    purchase_solicitation.change_status!(status)
  end

  def in_process_status
    @in_process_status ||= PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS
  end

  def pending_status
    @pending_status ||= PurchaseSolicitationServiceStatus::PENDING
  end
end
