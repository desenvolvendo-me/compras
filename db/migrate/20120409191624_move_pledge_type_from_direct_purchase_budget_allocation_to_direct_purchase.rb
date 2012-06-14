class MovePledgeTypeFromDirectPurchaseBudgetAllocationToDirectPurchase < ActiveRecord::Migration
  class DirectPurchase < ActiveRecord::Base
  end

  def change
    add_column :direct_purchases, :pledge_type, :string

    DirectPurchase.all.each do |direct_purchase|
      begin
        direct_purchase.update_attributes! :pledge_type => direct_purchase.direct_purchase_budget_allocations.first.try(:pledge_type) || 'Estimativo'
      rescue
      end
    end

    remove_column :direct_purchase_budget_allocations, :pledge_type
  end
end