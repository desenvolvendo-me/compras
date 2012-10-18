class DirectPurchaseBudgetAllocationCleaner
  def self.clear_old_records(direct_purchase, purchase_solicitation, item_group)
    return unless direct_purchase.purchase_solicitation != purchase_solicitation ||
                  direct_purchase.purchase_solicitation_item_group != item_group

    direct_purchase.direct_purchase_budget_allocations.each(&:mark_for_destruction)
  end
end