class DirectPurchaseStatusUpdater
  def initialize(direct_purchase_liberation)
    @liberation = direct_purchase_liberation
    @direct_purchase = direct_purchase_liberation.direct_purchase
  end

  def update!
    @direct_purchase.update_status!(@liberation.evaluation)
  end
end
