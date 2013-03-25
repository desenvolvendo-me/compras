class DirectPurchaseBudgetAllocationCleaner
  def self.clear_old_records(direct_purchase, purchase_solicitation)
    return unless direct_purchase.purchase_solicitation != purchase_solicitation

    direct_purchase.direct_purchase_budget_allocations.each(&:mark_for_destruction)
  end
end
