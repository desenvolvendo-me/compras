class AddCodeToDirectPurchaseWithoutCode < ActiveRecord::Migration
  def change
    DirectPurchase.where { direct_purchase.eq(nil) }.each do |direct_purchase|
      direct_purchase.update_attribute :direct_purchase, direct_purchase.next_purchase
    end
  end
end
