class DirectPurchaseAnnulment
  attr_accessor :direct_purchase, :item_group_annulment, :resource_annul

  def initialize(direct_purchase,
                 resource_annul,
                 item_group_annulment = PurchaseSolicitationItemGroupAnnulment)
    self.direct_purchase = direct_purchase
    self.item_group_annulment = item_group_annulment
    self.resource_annul = resource_annul
  end

  def annul
    annul_purchase_solicitation_item_group
  end

  private

  def annul_purchase_solicitation_item_group
    return unless purchase_solicitation_item_group.present?

    item_group_annulment.new(purchase_solicitation_item_group).
                         create_annulment(
                           resource_annul.employee,
                           resource_annul.date,
                           resource_annul.description
                         )
  end

  def purchase_solicitation_item_group
    direct_purchase.purchase_solicitation_item_group
  end
end
