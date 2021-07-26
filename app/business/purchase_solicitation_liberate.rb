class PurchaseSolicitationLiberate
  attr_accessor :purchase_solicitation

  def initialize(purchase_solicitation)
    self.purchase_solicitation = purchase_solicitation
  end

  def liberate!
    return unless purchase_solicitation

    purchase_solicitation.liberate!
  end
end
