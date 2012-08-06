class UpdateDirectPurchasesTotalAllocationsItemsValue < ActiveRecord::Migration
  class DirectPurchase < Compras::Model
    has_many :direct_purchase_budget_allocations
    has_many :items, :through => :direct_purchase_budget_allocations, :class_name => :DirectPurchaseBudgetAllocationItem

    def update_total_allocations_items_value!
      update_column(:total_allocations_items_value,  direct_purchase_budget_allocations.collect(&:total_items_value).sum)
    end
  end

  class DirectPurchaseBudgetAllocation < Compras::Model
    has_many :items, :class_name => 'DirectPurchaseBudgetAllocationItem'

    def total_items_value
      items.collect(&:estimated_total_price).sum
    end
  end

  class DirectPurchaseBudgetAllocationItem < Compras::Model
    belongs_to :direct_purchase_budget_allocation

    def estimated_total_price
      return 0 unless quantity && unit_price

      quantity * unit_price
    end
  end

  def change
    DirectPurchase.find_each do |direct_purchase|
      direct_purchase.update_total_allocations_items_value!
    end
  end
end
