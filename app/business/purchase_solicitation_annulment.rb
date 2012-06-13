class PurchaseSolicitationAnnulment
  def initialize(solicitation)
    @solicitation = solicitation
  end

  def annul!
    return false unless @solicitation.annul.present?

    @solicitation.annul!
  end
end
