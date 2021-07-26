class UpdateItemGroupStatuses < ActiveRecord::Migration

  class SupplyAuthorization < Compras::Model
  end

  class DirectPurchase < Compras::Model
    has_one :supply_authorization
  end

  class PurchaseSolicitationItemGroup < Compras::Model
    has_many :direct_purchases
  end

  def change
    PurchaseSolicitationItemGroup.all.each do |item_group|
      if item_group.direct_purchases.any?
        item_group.direct_purchases.each do |purchase|
          if purchase.supply_authorization.present?
            item_group.update_column(:status, 'fulfilled')
          else
            item_group.update_column(:status, 'in_purchase_process')
          end
        end
      else
        item_group.update_column(:status, 'pending')
      end
    end
  end
end
