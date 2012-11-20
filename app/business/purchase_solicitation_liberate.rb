class PurchaseSolicitationLiberate
  attr_accessor :purchase_solicitation

  delegate :direct_purchase, :to => :purchase_solicitation

  def initialize(purchase_solicitation)
    self.purchase_solicitation = purchase_solicitation
  end

  def liberate!
    return unless purchase_solicitation

    direct_purchase.remove_purchase_solicitation! if direct_purchase
    purchase_solicitation.liberate!
  end
end
