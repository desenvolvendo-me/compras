class ChangeDefaultValueOfPurchaseSolicitationItemsGrouped < ActiveRecord::Migration
  def up
    change_column_default :purchase_solicitation_items, :grouped,  false
  end

  def down
    change_column_default :purchase_solicitation_items, :grouped,  nil
  end
end
