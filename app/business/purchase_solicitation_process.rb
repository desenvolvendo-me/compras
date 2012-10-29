class PurchaseSolicitationProcess
  def self.update_solicitations_status(new_solicitation, old_solicitation = nil)
    return unless new_solicitation != old_solicitation

    change_solicitation_status(old_solicitation, PurchaseSolicitationServiceStatus::PENDING)
    change_solicitation_status(new_solicitation, PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)
  end

  private

  def self.change_solicitation_status(purchase_solicitation, status)
    return if purchase_solicitation.nil?

    purchase_solicitation.change_status!(status)
  end
end
