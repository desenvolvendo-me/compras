class PurchaseSolicitationItemReport < Report
  attr_accessor  :purchase_solicitation_id

  def purchase_solicitation
    PurchaseSolicitation.find(purchase_solicitation_id) if purchase_solicitation_id
  end

  def items
    purchase_solicitation.items
  end

  def prefecture
    Prefecture.last.name
  end
end
